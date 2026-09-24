//
//  CanvasAnimView.swift
//  Canvas-Explore
//
//  Created by jht2 on 1/26/25.
//

import SwiftUI

// Animated 10PRINT: one random slash appears per timeline tick,
// sweeping left-to-right, top-to-bottom, then clearing and starting over.
// Like TenPrintView, the model (array of slash specs) is separate from
// the rendering (the Canvas); the TimelineView drives the model forward.

// See UIGraphicsImageRenderer version:
// https://github.com/molab-itp/01-UIRender-playground / 10print save

// One slash in the grid: where it starts, which diagonal, and its color
struct SlashSpec {
  var origin: CGPoint
  var leftToRight: Bool
  var color: Color
}

struct CanvasAnimView: View {
  @State private var slashes: [SlashSpec] = []
  @State private var loc: CGPoint = .zero

  let animInterval = 0.10 // add a slash every tenth of a second
  let ncell = 10.0
  let lineWidth = 10.0
  let palette = [Color.red, Color.green, Color.yellow, Color.black]

  var body: some View {
    TimelineView(.animation(minimumInterval: animInterval)) { timeline in
      GeometryReader { geo in
        Canvas { context, size in
          let cellSize = size.width / ncell
          let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round)
          for slash in slashes {
            context.stroke(path(for: slash, cellSize: cellSize),
                           with: .color(slash.color), style: style)
          }
        }
        // Advance the model on timeline ticks, not inside the draw closure
        .onChange(of: timeline.date) {
          advance(in: geo.size)
        }
      }
    }
  }

  // Build a diagonal line path for one cell
  func path(for slash: SlashSpec, cellSize: CGFloat) -> Path {
    var path = Path()
    if slash.leftToRight {
      // Diagonal from top-left to bottom-right: "\"
      path.move(to: slash.origin)
      path.addLine(to: CGPoint(x: slash.origin.x + cellSize,
                               y: slash.origin.y + cellSize))
    } else {
      // Diagonal from top-right to bottom-left: "/"
      path.move(to: CGPoint(x: slash.origin.x + cellSize, y: slash.origin.y))
      path.addLine(to: CGPoint(x: slash.origin.x, y: slash.origin.y + cellSize))
    }
    return path
  }

  // Add one random slash at the current location, then step to the next cell;
  // when the grid is full, clear and start over from the top
  func advance(in size: CGSize) {
    let cellSize = size.width / ncell
    guard cellSize > 0 else { return }
    slashes.append(SlashSpec(origin: loc,
                             leftToRight: Bool.random(),
                             color: palette.randomElement()!))
    loc.x += cellSize
    if loc.x > size.width {
      loc.x = 0
      loc.y += cellSize
      if loc.y > size.height {
        loc.y = 0
        slashes = []
      }
    }
  }
}

#Preview {
  CanvasAnimView()
}
