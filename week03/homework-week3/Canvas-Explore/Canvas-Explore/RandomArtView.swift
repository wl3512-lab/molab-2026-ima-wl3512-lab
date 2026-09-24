//
//  RandomArtView.swift
//  Canvas-Explore
//

import SwiftUI

// An image composed of random elements:
// an array of circles, each with random position, size, color, and opacity.

struct CircleSpec {
  var center: CGPoint
  var radius: CGFloat
  var color: Color
  var opacity: Double
}

struct RandomArtView: View {
  @State private var circles: [CircleSpec] = []
  @State private var canvasSize: CGSize = .zero

  let count = 80
  let palette = [Color.red, .orange, .yellow, .green, .blue, .purple]

  var body: some View {
    VStack {
      GeometryReader { geo in
        Canvas { context, size in
          // Drawing order matters: later circles paint over earlier ones
          for c in circles {
            let rect = CGRect(x: c.center.x - c.radius,
                              y: c.center.y - c.radius,
                              width: c.radius * 2,
                              height: c.radius * 2)
            let path = Path(ellipseIn: rect)
            context.fill(path, with: .color(c.color.opacity(c.opacity)))
          }
        }
        .background(Color.black)
        .onAppear {
          canvasSize = geo.size
          regenerate()
        }
      }
      Button("Regenerate") {
        regenerate()
      }
      .buttonStyle(.borderedProminent)
      .padding(.bottom)
    }
  }

  // Build a fresh array of random circle specs
  func regenerate() {
    guard canvasSize.width > 0 else { return }
    circles = (0..<count).map { _ in
      CircleSpec(center: CGPoint(x: .random(in: 0...canvasSize.width),
                                 y: .random(in: 0...canvasSize.height)),
                 radius: .random(in: 10...60),
                 color: palette.randomElement()!,
                 opacity: .random(in: 0.3...0.9))
    }
  }
}

#Preview {
  RandomArtView()
}
