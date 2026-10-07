//
// UI Controls with @State
//  Toggle, Slider and Picker

import SwiftUI
import UIKit

struct Page7: View {
    
  @State var len = 100.0
  @State var fillFlag = true
  @State var selectedImage = "circle"
    
  var body: some View {
    VStack() {
      Image(systemName: selectedImage  + (fillFlag ? ".fill" : "") )
        .resizable()
        .frame(width: len, height: len)
      Toggle(isOn: $fillFlag) {
        Text("Fill")
      }
      Slider(value: $len, in: 100.0...400.0)
      Text("len \(len)")
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


