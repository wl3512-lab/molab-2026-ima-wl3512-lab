import SwiftUI

// messing around with basic canvas shapes, stacked top to bottom
struct ContentView: View {
  var body: some View {
    Canvas { context, size in
      let lineWidth = 10.0

      // each shape gets a quarter of the screen height
      let nsize = CGSize(width: size.width, height: size.height/4)

      // rect starts at top left, gets moved down for each shape
      var arect = CGRect(origin: .zero, size: nsize)

      // ellipse
      let ellipsePath = Path(ellipseIn: arect)
      context.stroke(ellipsePath, with: .color(.red), lineWidth: lineWidth)

      // rectangle
      arect.origin.y += nsize.height
      let rectPath = Rectangle().path(in: arect)
      context.stroke(rectPath, with: .color(.green), lineWidth: lineWidth)

      // capsule
      arect.origin.y += nsize.height
      let capsule = Capsule().path(in: arect)
      context.stroke(capsule, with: .color(.yellow), lineWidth: lineWidth)

      // diagonal line, top left down to bottom right
      arect.origin.y += nsize.height
      var path = Path()
      path.move(to: arect.origin)
      arect.origin.y += nsize.height
      var apoint = arect.origin
      apoint.x += arect.size.width
      path.addLine(to: apoint)
      context.stroke(path, with: .color(.yellow), lineWidth: lineWidth)
    }
  }
}

#Preview {
  ContentView()
}
