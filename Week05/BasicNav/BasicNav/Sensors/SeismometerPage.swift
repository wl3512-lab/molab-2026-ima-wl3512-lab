//
// seismometer (from 05-Seismometer, apple's sample app)
// put the phone on a table and tap the table: the needle jumps and the graph draws the shake
// the class version used NavigationSplitView with 2 links. mine already has a NavigationStack,
// so i switch between Needle and Graph with a segmented picker instead
// sensors don't work in the simulator, run it on your phone

import SwiftUI

struct SeismometerPage: View {
  // the page makes its own motion detector
  @State private var motionDetector = MotionDetector(updateInterval: 0.01)
  // false = needle, true = graph
  @State private var showGraph = false

  var body: some View {
    VStack {
      // segmented = the two-button switch thing
      Picker("View", selection: $showGraph) {
        Text("Needle").tag(false)
        Text("Graph").tag(true)
      }
      .pickerStyle(.segmented)
      .padding()

      if showGraph {
        GraphSeismometer()
      } else {
        NeedleSeismometer()
      }
    }
    // hand the detector to both views
    .environment(motionDetector)
    .navigationTitle("Seismometer")
    // sensors on when the page opens, off when i leave
    .onAppear { motionDetector.start() }
    .onDisappear { motionDetector.stop() }
  }
}

// a needle that swings when the phone shakes
struct NeedleSeismometer: View {
  @Environment(MotionDetector.self) private var motionDetector

  // spin the needle around its bottom middle
  let needleAnchor = UnitPoint(x: 0.5, y: 1)
  // make small shakes look bigger
  let amplification = 2.0

  // shake amount -> needle angle
  var rotationAngle: Angle {
    Angle(radians: -motionDetector.zAcceleration * amplification)
  }

  var body: some View {
    VStack {
      Spacer()
      // .bottom = line everything up along the bottom edge
      ZStack(alignment: .bottom) {
        // the half circle with tick marks
        GaugeBackground(width: 250)
        // the needle
        Rectangle()
          .foregroundColor(Color.accentColor)
          .frame(width: 5, height: 190)
          .rotationEffect(rotationAngle, anchor: needleAnchor)
          // the little round pin at the bottom of the needle
          .overlay {
            VStack {
              Spacer()
              Circle()
                .stroke(lineWidth: 3)
                .fill()
                .frame(width: 10, height: 10)
                .foregroundColor(Color.accentColor)
                .background(Color.white)
                .offset(x: 0, y: 5)
            }
          }
      }
      Spacer()
      // the actual number
      Text("\(motionDetector.zAcceleration.describeAsFixedLengthString())")
        .font(.system(.body, design: .monospaced))
        .fontWeight(.bold)
      Spacer()
      Text("Set your device on a flat surface to record vibrations using its motion sensors.")
        .padding()
      Spacer()
    }
  }
}

// lets me use an Angle inside ForEach (ForEach needs an id)
extension Angle: @retroactive Identifiable {
  public var id: Double { radians }
}

// the half circle behind the needle, with tick marks
struct GaugeBackground: View {
  let width: Double
  let minAngle = Angle(degrees: -90)
  let maxAngle = Angle(degrees: 90)
  let tickCount = 17

  var tickLength: Double { width * 0.05 }

  // work out the angle for every tick (skipping the 2 ends)
  var gaugeTickAngles: [Angle] {
    let tickDegrees = (maxAngle.degrees - minAngle.degrees) / (Double(tickCount) - 1)
    var angles = [Angle]()
    for tick in 1..<tickCount - 1 {
      angles.append(Angle(degrees: 90 - (Double(tick) * tickDegrees)))
    }
    return angles
  }

  var body: some View {
    ZStack {
      // the filled half circle
      Path { path in
        path.addArc(center: CGPoint(x: width / 2, y: width / 2),
                    radius: width / 2,
                    startAngle: Angle(degrees: minAngle.degrees + 90),
                    endAngle: Angle(degrees: maxAngle.degrees + 90),
                    clockwise: true)
      }
      .fill()
      .foregroundColor(Color.accentColor.opacity(0.15))
      // one little line per tick, rotated into place
      ForEach(gaugeTickAngles) { angle in
        Rectangle()
          .frame(width: 1, height: tickLength)
          .offset(y: -width / 2 + tickLength)
          .rotationEffect(angle, anchor: UnitPoint(x: 0.5, y: 1))
          .offset(y: width / 4 - tickLength / 2)
      }
    }
    .frame(width: width, height: width / 2)
  }
}

// a live line graph of the shaking + a sensitivity slider
struct GraphSeismometer: View {
  @Environment(MotionDetector.self) private var detector
  // every reading so far (the newest 1000)
  @State private var data = [Double]()
  let maxData = 1000
  // 0 = least sensitive, 1 = most
  @State private var sensitivity = 0.0

  // how tall the graph goes. more sensitive = smaller max = little shakes look bigger
  let graphMaxValueMostSensitive = 0.01
  let graphMaxValueLeastSensitive = 1.0
  var graphMaxValue: Double {
    graphMaxValueMostSensitive + (1 - sensitivity) * (graphMaxValueLeastSensitive - graphMaxValueMostSensitive)
  }
  var graphMinValue: Double { -graphMaxValue }

  var body: some View {
    VStack {
      Spacer()
      LineGraph(data: data, maxData: maxData, minValue: graphMinValue, maxValue: graphMaxValue)
        .clipped()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(20)
        .padding()
        .aspectRatio(1, contentMode: .fit)
      Spacer()
      Text("Sensitivity")
        .font(.headline)
      Slider(value: $sensitivity, in: 0...1,
             minimumValueLabel: Text("Min"), maximumValueLabel: Text("Max")) {
        Text("Sensitivity")
      }
      .padding()
      Spacer()
      Text("Set your device on a flat surface to record vibrations using its motion sensors.")
        .padding()
      Spacer()
    }
    .onAppear {
      // every time the detector checks, add the new reading to the graph
      detector.onUpdate = {
        data.append(-detector.zAcceleration)
        // keep only the newest 1000, drop the oldest
        if data.count > maxData {
          data = Array(data.dropFirst())
        }
      }
    }
  }
}

// draws the graph with Canvas (like drawing in p5, but swiftui)
struct LineGraph: View {
  let data: [Double]
  let maxData: Int
  let minValue: Double
  let maxValue: Double
  let gridSpacing = 250
  // goes up by 1 every new reading, so the grid scrolls along
  @State private var timestep = 0

  // a reading -> how far down the graph it goes
  func yGraphPosition(_ dataItem: Double, in size: CGSize) -> Double {
    let proportion = (dataItem - minValue) / (maxValue - minValue)
    return size.height - proportion * size.height
  }

  // a reading's spot in the list -> how far across. newest is on the right
  func xGraphPosition(_ index: Int, in size: CGSize) -> Double {
    let increment = size.width / Double(maxData)
    let base = Double(maxData - data.count) * increment
    return base + Double(index) * increment
  }

  var body: some View {
    // Canvas = a blank area i draw on with code
    Canvas { context, size in
      // 1. the grid lines
      var lines = Path()
      let increment = size.width / Double(maxData)
      let phase = -1 * timestep % gridSpacing
      var x = Double(phase)
      repeat {
        // vertical lines, shifted by timestep so they scroll
        lines.move(to: CGPoint(x: x * increment, y: 0))
        lines.addLine(to: CGPoint(x: x * increment, y: size.height))
        x += Double(gridSpacing)
      } while x <= Double(maxData)
      // horizontal lines from the middle going down...
      var y = size.height / 2
      repeat {
        lines.move(to: CGPoint(x: 0, y: y))
        lines.addLine(to: CGPoint(x: size.width, y: y))
        y += increment * Double(gridSpacing)
      } while y <= size.height
      // ...and from the middle going up
      y = size.height / 2
      repeat {
        lines.move(to: CGPoint(x: 0, y: y))
        lines.addLine(to: CGPoint(x: size.width, y: y))
        y -= increment * Double(gridSpacing)
      } while y >= 0
      context.stroke(lines, with: .color(.black.opacity(0.25)))

      // 2. the actual line, dot to dot through every reading
      guard !data.isEmpty else { return }
      var path = Path()
      path.move(to: CGPoint(x: xGraphPosition(0, in: size), y: yGraphPosition(data[0], in: size)))
      for (index, dataPoint) in data.dropFirst().enumerated() {
        path.addLine(to: CGPoint(x: xGraphPosition(index, in: size), y: yGraphPosition(dataPoint, in: size)))
      }
      context.stroke(path, with: .color(.accentColor))
    }
    // new reading came in -> move the grid along
    .onChange(of: data) {
      timestep += 1
    }
  }
}

#Preview {
  NavigationStack { SeismometerPage() }
}

// from https://github.com/molab-itp/05-Seismometer
// apple tutorial: https://developer.apple.com/tutorials/sample-apps/seismometer
