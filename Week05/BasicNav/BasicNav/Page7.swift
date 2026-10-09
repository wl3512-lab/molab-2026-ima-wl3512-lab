//
// page 7: controls with @State
// Toggle = fill on/off, Slider = size, Picker = which shape

import SwiftUI
import UIKit

struct Page7: View {

  // @State = little variables this page remembers while it's open
  // (they reset when you close the app, page 8 fixes that)
  @State var len = 100.0
  @State var fillFlag = true
  @State var selectedImage = "circle"

  var body: some View {
    VStack() {
      // the shape. if fill is on, add ".fill" to the name (circle -> circle.fill)
      Image(systemName: selectedImage  + (fillFlag ? ".fill" : "") )
        .resizable()
        // width + height come from the slider
        .frame(width: len, height: len)
      // $fillFlag = the toggle can change fillFlag directly (that's a binding)
      Toggle(isOn: $fillFlag) {
        Text("Fill")
      }
      // drag between 100 and 400
      Slider(value: $len, in: 100.0...400.0)
      Text("len \(len)")
      // pick a shape. .tag = what selectedImage becomes when you pick that row
      Picker("Image Name", selection: $selectedImage) {
        Text("circle").tag("circle")
        Text("flag").tag("flag")
        Text("ear").tag("ear")
      }
    }
  }
}

#Preview {
    Page7()
}
