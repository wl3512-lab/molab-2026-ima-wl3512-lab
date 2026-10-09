//
// heart shape + animation (from 05-Heart-Shapes)
// i draw my own shape (a heart) with a Path, then make it pulse with an animation
// the Play/Reset button uses @Binding again, like the timer

import SwiftUI

struct HeartPulseView: View {
  // is it pulsing right now? the button flips this
  @State private var pulsing = false

  var body: some View {
    VStack {
      Spacer()
      ZStack {
        // pulsing = the animated heart, otherwise the still one
        if pulsing {
          PulsingHeart()
        } else {
          ResetHeart()
        }
      }
      Spacer()
      // $pulsing = give the button the remote control so it can flip it
      PlayResetButton(animating: $pulsing)
    }
    .navigationTitle("Basic Animation")
    .navigationBarTitleDisplayMode(.inline)
  }
}

// the heart just sitting there
struct ResetHeart: View {
  var body: some View {
    Heart()
      .frame(width: 100, height: 100)
      .foregroundColor(.red)
      .shadow(color: .pink, radius: 10)
      // a bigger invisible box around it so the layout doesn't jump when it grows
      .frame(width: 300, height: 300)
  }
}

// the heart that grows and shrinks forever
struct PulsingHeart: View {
  // 1 = normal size
  @State private var heartPulse: CGFloat = 1

  var body: some View {
    Heart()
      .frame(width: 100, height: 100)
      .foregroundColor(.red)
      // scale by heartPulse (1 = normal, 4 = 4x bigger)
      .scaleEffect(heartPulse)
      .shadow(color: .pink, radius: 10)
      .onAppear {
        // as soon as it shows up: animate to 4x, ease in + out,
        // repeatForever + autoreverses = grow, shrink, grow, shrink...
        withAnimation(.easeInOut.repeatForever(autoreverses: true)) {
          heartPulse = 4.0 * heartPulse
          print("heartPulse", heartPulse)
        }
      }
  }
}

// my own shape. Shape = i just describe the outline, swiftui fills it in
struct Heart: Shape {
  // rect = the box the heart has to fit in
  func path(in rect: CGRect) -> Path {
    var path = Path()

    // start at the bottom point of the heart
    path.move(to: CGPoint(x: rect.midX, y: rect.maxY))

    // curve up the left side
    path.addCurve(to: CGPoint(x: rect.minX, y: rect.height / 4),
                  control1: CGPoint(x: rect.midX, y: rect.height * 3 / 4),
                  control2: CGPoint(x: rect.minX, y: rect.midY))

    // left bump (half circle)
    path.addArc(center: CGPoint(x: rect.width / 4, y: rect.height / 4),
                radius: rect.width / 4,
                startAngle: Angle(radians: Double.pi),
                endAngle: Angle(radians: 0),
                clockwise: false)

    // right bump (half circle)
    path.addArc(center: CGPoint(x: rect.width * 3 / 4, y: rect.height / 4),
                radius: rect.width / 4,
                startAngle: Angle(radians: Double.pi),
                endAngle: Angle(radians: 0),
                clockwise: false)

    // curve back down the right side to the bottom point
    path.addCurve(to: CGPoint(x: rect.midX, y: rect.height),
                  control1: CGPoint(x: rect.width, y: rect.midY),
                  control2: CGPoint(x: rect.midX, y: rect.height * 3 / 4))
    return path
  }
}

// a reusable look for buttons (ButtonStyle), so every button using it matches
struct ShapesButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    // configuration.label = whatever's inside the button
    configuration.label
      .padding()
      .frame(minWidth: 125, minHeight: 60)
      .background(Color.blue.opacity(0.15))
      .foregroundColor(.blue)
      .clipShape(RoundedRectangle(cornerRadius: 15))
      .padding(.bottom, 30)
  }
}

// the Play / Reset button
struct PlayResetButton: View {
  // borrows "pulsing" from HeartPulseView
  @Binding var animating: Bool
  var resetOnly: Bool = false
  // extra thing to run on tap (nothing by default)
  var action: () -> Void = { }

  var body: some View {
    Button {
      // flip it. this changes HeartPulseView's pulsing too, because it's a binding
      animating.toggle()
      action()
    } label: {
      if resetOnly {
        Label("Reset", systemImage: "arrow.counterclockwise")
      } else {
        // label + icon swap depending on what's happening
        Label(animating ? "Reset" : "Play",
              systemImage: animating ? "arrow.counterclockwise" : "play.fill")
      }
    }
    .buttonStyle(ShapesButton())
  }
}

#Preview {
  NavigationStack { HeartPulseView() }
}

// from https://github.com/molab-itp/05-Heart-Shapes (apple's "Animating shapes" sample)
