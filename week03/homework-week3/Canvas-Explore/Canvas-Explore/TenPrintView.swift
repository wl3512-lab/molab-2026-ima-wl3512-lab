import SwiftUI

// one cell = which way the slash leans + its color
struct TenPrintCell {
  var leftToRight: Bool
  var color: Color
}

// 10print but static, whole grid gets made at once then drawn in one go
struct TenPrintView: View {
  // 2d array holds the whole picture, changing it redraws the canvas
  @State private var grid: [[TenPrintCell]] = []
  @State private var canvasSize: CGSize = .zero

  let ncols = 12
  let palette = [Color.red, Color.green, Color.yellow, Color.black]

  var body: some View {
    VStack {
      GeometryReader { geo in
        Canvas { context, size in
          // cell size comes from screen width / number of columns
          let cellSize = size.width / CGFloat(ncols)
          let style = StrokeStyle(lineWidth: 6, lineCap: .round)
          for (row, rowCells) in grid.enumerated() {
            for (col, cell) in rowCells.enumerated() {
              // turn row/col into actual x/y on screen
              let x = CGFloat(col) * cellSize
              let y = CGFloat(row) * cellSize
              var path = Path()
              if cell.leftToRight {
                // "\" slash
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + cellSize, y: y + cellSize))
              } else {
                // "/" slash
                path.move(to: CGPoint(x: x + cellSize, y: y))
                path.addLine(to: CGPoint(x: x, y: y + cellSize))
              }
              context.stroke(path, with: .color(cell.color), style: style)
            }
          }
        }
        .onAppear {
          // need the size before we can build the grid
          canvasSize = geo.size
          regenerate()
        }
      }
      // reroll the whole picture
      Button("Regenerate") {
        regenerate()
      }
      .buttonStyle(.borderedProminent)
      .padding(.bottom)
    }
  }

  // fill the array with fresh random cells, enough rows to cover the screen
  func regenerate() {
    let cellSize = canvasSize.width / CGFloat(ncols)
    guard cellSize > 0 else { return }
    let nrows = Int(ceil(canvasSize.height / cellSize))
    grid = (0..<nrows).map { _ in
      (0..<ncols).map { _ in
        // coin flip for direction, random color from palette
        TenPrintCell(leftToRight: Bool.random(),
                     color: palette.randomElement()!)
      }
    }
  }
}

#Preview {
  TenPrintView()
}
