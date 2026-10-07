//
// Picker ForEach
//  same controls as Page7, but saved with @AppStorage (05-AppStorageDemo)
//  close the app and open it again, the shape is still how you left it

import SwiftUI
import UIKit

struct Page8: View {
    
  @AppStorage("len") var len = 100.0
  @AppStorage("fillFlag") var fillFlag = true
  @AppStorage("selectedImage") var selectedImage = "circle"
    
  var body: some View {
    VStack() {
      ExtractedView(selectedImage: selectedImage, fillFlag: fillFlag, len: len)
      Toggle(isOn: $fillFlag) {
        Text("Fill")
      }
      Slider(value: $len, in: 100.0...400.0)
      Text("len \(len)")
      Picker("Image Name", selection: $selectedImage) {
        ForEach(0 ..< imageArray.count, id: \.self) { 
            index in
          let item = imageArray[index]
          Text(item).tag(item)
        }
      }
    }
  }
}

struct ExtractedView: View {
    
  var selectedImage: String
  var fillFlag: Bool
  var len: Double
    
  var body: some View {
    Image(systemName: selectedImage  + (fillFlag ? ".fill" : "") )
      .resizable()
      .frame(width: len, height: len)
  }
}

#Preview {
    Page8()
}



