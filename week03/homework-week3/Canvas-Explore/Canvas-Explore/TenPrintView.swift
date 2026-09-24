//
//  TenPrintView.swift
//  Canvas-Explore
//

import SwiftUI

// Static 10PRINT: instead of animating one cell at a time (see CanvasAnimView),
// generate the whole grid of random slashes up front into a 2D array,
// then draw the finished image in a single Canvas pass.
// Model (the array of cells) is separate from rendering (the Canvas).

// One cell of the grid: which diagonal to draw, and in what color
struct TenPrintCell {
  var leftToRight: Bool
  var color: Color
}

struct TenPrintView: View {
  // The image "recipe" lives in this 2D array; changing it redraws the Canvas
  @State private var grid: [[TenPrintCell]] = []
  @State private var canvasSize: CGSize = .zero

  let ncols = 12
  let palette = [Color.red, Color.green, Color.yellow, Color.black]

  var body: some View {
    VStack {
      GeometryReader { geo in
        Canvas { context, size in
          let cellSize = size.width / CGFloat(ncols)
          let style = StrokeStyle(lineWidth: 6, lineCap: .round)
          for (row, rowCells) in grid.enumerated() {
            for (col, cell) in rowCells.enumerated() {
              // Convert grid coordinates (row, col) to canvas points
              let x = CGFloat(col) * cellSize
              let y = CGFloat(row) * cellSize
              var path = Path()
              if cell.leftToRight {
                // Diagonal from top-left to bottom-right: "\"
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + cellSize, y: y + cellSize))
              } else {
                // Diagonal from top-right to bottom-left: "/"
                path.move(to: CGPoint(x: x + cellSize, y: y))
                path.addLine(to: CGPoint(x: x, y: y + cellSize))
              }
              context.stroke(path, with: .color(cell.color), style: style)
            }
          }
        }
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

  // Fill the 2D array with fresh random cells; enough rows to cover the height
  func regenerate() {
    let cellSize = canvasSize.width / CGFloat(ncols)
    guard cellSize > 0 else { return }
    let nrows = Int(ceil(canvasSize.height / cellSize))
    grid = (0..<nrows).map { _ in
      (0..<ncols).map { _ in
        TenPrintCell(leftToRight: Bool.random(),
                     color: palette.randomElement()!)
      }
    }
  }
}

#Preview {
  TenPrintView()
}
