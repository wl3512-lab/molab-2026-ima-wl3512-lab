//
// bubble level (from 05-BubbleLevel, apple's sample app)
// tilt the phone and the blue bubble moves, like a real level
// sensors don't work in the simulator, run it on your phone

import SwiftUI

// the page i link to from home. it makes its own motion detector and hands it down
struct BubbleLevelPage: View {
  // checks the sensors 100x a second
  @State private var motionDetector = MotionDetector(updateInterval: 0.01)

  var body: some View {
    LevelView()
      // .environment = every view inside can grab the detector without passing it by hand
      .environment(motionDetector)
      .navigationTitle("Bubble level")
  }
}

// the level + the numbers under it
struct LevelView: View {
  @Environment(MotionDetector.self) var motionDetector

  var body: some View {
    VStack {
      BubbleLevel()
      OrientationDataView()
        .padding(.top, 80)
    }
    // sensors on when the page opens, off when i leave
    .onAppear { motionDetector.start() }
    .onDisappear { motionDetector.stop() }
  }
}

// the circle with the moving bubble
struct BubbleLevel: View {
  @Environment(MotionDetector.self) var detector

  // pi = how far you can tilt before the bubble hits the edge
  let range = Double.pi
  // how big the circle is
  let levelSize: CGFloat = 300

  // turn roll (left/right tilt) into an x position inside the circle
  var bubbleXPosition: CGFloat {
    let zeroBasedRoll = detector.roll + range / 2   // shift so it starts at 0
    let rollAsFraction = zeroBasedRoll / range      // 0 = far left, 1 = far right
    return rollAsFraction * levelSize               // -> actual points
  }

  // same thing for pitch (forward/back tilt) -> y position
  var bubbleYPosition: CGFloat {
    let zeroBasedPitch = detector.pitch + range / 2
    let pitchAsFraction = zeroBasedPitch / range
    return pitchAsFraction * levelSize
  }

  // little tick marks
  var verticalLine: some View {
    Rectangle().frame(width: 0.5, height: 40)
  }
  var horizontalLine: some View {
    Rectangle().frame(width: 40, height: 0.5)
  }

  var body: some View {
    // the big grey circle
    Circle()
      .foregroundStyle(Color.secondary.opacity(0.25))
      .frame(width: levelSize, height: levelSize)
      // overlay = draw stuff on top of it
      .overlay(
        ZStack {
          // the bubble, placed where the tilt says
          Circle()
            .foregroundColor(.accentColor)
            .frame(width: 50, height: 50)
            .position(x: bubbleXPosition, y: bubbleYPosition)
          // the little target ring in the middle
          Circle()
            .stroke(lineWidth: 0.5)
            .frame(width: 20, height: 20)
          // crosshair in the middle
          verticalLine
          horizontalLine
          // tick marks at top, bottom, left, right
          verticalLine.position(x: levelSize / 2, y: 0)
          verticalLine.position(x: levelSize / 2, y: levelSize)
          horizontalLine.position(x: 0, y: levelSize / 2)
          horizontalLine.position(x: levelSize, y: levelSize / 2)
        }
      )
  }
}

// the numbers under the level
struct OrientationDataView: View {
  @Environment(MotionDetector.self) var detector

  var rollString: String { detector.roll.describeAsFixedLengthString() }
  var pitchString: String { detector.pitch.describeAsFixedLengthString() }

  var body: some View {
    VStack {
      // monospaced = every number the same width so they don't jump around
      Text("Horizontal: " + rollString)
        .font(.system(.body, design: .monospaced))
      Text("Vertical: " + pitchString)
        .font(.system(.body, design: .monospaced))
    }
  }
}

#Preview {
  NavigationStack { BubbleLevelPage() }
}

// from https://github.com/molab-itp/05-BubbleLevel
// apple tutorial: https://developer.apple.com/tutorials/sample-apps/bubblelevel
