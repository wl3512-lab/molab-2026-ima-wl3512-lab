//
// page 8: same controls as page 7, but saved with @AppStorage (05-AppStorageDemo)
// close the app and open it again, the shape is still how you left it

import SwiftUI
import UIKit

struct Page8: View {

  // @AppStorage("name") = @State that saves to the phone (UserDefaults)
  // the name in quotes is the key it's saved under
  @AppStorage("len") var len = 100.0
  @AppStorage("fillFlag") var fillFlag = true
  @AppStorage("selectedImage") var selectedImage = "circle"

  var body: some View {
    VStack() {
      // the shape, moved into its own little view below
      ExtractedView(selectedImage: selectedImage, fillFlag: fillFlag, len: len)
      // these work exactly like page 7, the $ bindings don't care that it's AppStorage now
      Toggle(isOn: $fillFlag) {
        Text("Fill")
      }
      Slider(value: $len, in: 100.0...400.0)
      Text("len \(len)")
      // this time the picker lists every shape from imageArray with ForEach
      Picker("Image Name", selection: $selectedImage) {
        ForEach(0 ..< imageArray.count, id: \.self) {
            index in
          // index = 0, 1, 2... grab the name at that spot
          let item = imageArray[index]
          Text(item).tag(item)
        }
      }
    }
  }
}

// just the shape. it only reads the values, it doesn't change them (no $ needed)
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
