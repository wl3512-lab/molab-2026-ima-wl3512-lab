//
// one row in the image list: picture on the left, name on the right
// (ItemRow in the class demo, renamed because page 6 already has an ItemRow)

import SwiftUI

struct PhotoRow: View {
  var item: ItemModel
  // the downloaded picture. starts empty (nil) until it loads
  @State var uiImage: UIImage?

  var body: some View {
    HStack {
      // ZStack = stack things on top of each other
      ZStack {
        // 1. a picture from Assets, if there is one
        Image(item.assetName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 100, height: 100)
        // 2. the internet picture, only once it's loaded
        if let uiImage {
          Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
        }
        // 3. an sf symbol drawn on top, if there is one
        Image(systemName: item.systemName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 100, height: 100)
      }
      Text(item.label)
      Spacer()
    }
    // .task = do this in the background when the row shows up (downloading takes a sec)
    .task {
      uiImage = await imageFor(string: item.urlStr)
    }
  }
}

// download a picture from a link. nil if the link's bad
func imageFor(string str: String) async -> UIImage? {
  // guard = if any of these steps fail, give up and return nil
  guard let url = URL(string: str),
        let imgData = try? Data(contentsOf: url),
        let uiImage = UIImage(data: imgData)
  else {
    return nil
  }
  return uiImage
}

#Preview {
  PhotoRow(item: ItemModel(urlStr: photoUrls[0], label: "dan"))
}
