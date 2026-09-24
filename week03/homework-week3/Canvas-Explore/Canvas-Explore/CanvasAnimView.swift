import SwiftUI

// one slash = where it starts, which way it leans, what color
struct SlashSpec {
  var origin: CGPoint
  var leftToRight: Bool
  var color: Color
}

// animated 10print, one slash pops in per tick then it wipes and restarts
struct CanvasAnimView: View {
  // slashes drawn so far + where the next one goes
  @State private var slashes: [SlashSpec] = []
  @State private var loc: CGPoint = .zero

  let animInterval = 0.10
  let ncell = 10.0
  let lineWidth = 10.0
  let palette = [Color.red, Color.green, Color.yellow, Color.black]

  var body: some View {
    // timeline ticks every 0.1s and drives the animation
    TimelineView(.animation(minimumInterval: animInterval)) { timeline in
      GeometryReader { geo in
        Canvas { context, size in
          let cellSize = size.width / ncell
          let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round)
          // just draw whatever is in the array
          for slash in slashes {
            context.stroke(path(for: slash, cellSize: cellSize),
                           with: .color(slash.color), style: style)
          }
        }
        // add the next slash on each tick, not inside the draw closure
        .onChange(of: timeline.date) {
          advance(in: geo.size)
        }
      }
    }
  }

  // build the diagonal line for one cell
  func path(for slash: SlashSpec, cellSize: CGFloat) -> Path {
    var path = Path()
    if slash.leftToRight {
      // "\" slash
      path.move(to: slash.origin)
      path.addLine(to: CGPoint(x: slash.origin.x + cellSize,
                               y: slash.origin.y + cellSize))
    } else {
      // "/" slash
      path.move(to: CGPoint(x: slash.origin.x + cellSize, y: slash.origin.y))
      path.addLine(to: CGPoint(x: slash.origin.x, y: slash.origin.y + cellSize))
    }
    return path
  }

  // drop a random slash at the current spot then move to the next cell
  func advance(in size: CGSize) {
    let cellSize = size.width / ncell
    guard cellSize > 0 else { return }
    slashes.append(SlashSpec(origin: loc,
                             leftToRight: Bool.random(),
                             color: palette.randomElement()!))
    loc.x += cellSize
    // wrap to next row at the right edge, wipe and restart at the bottom
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
