//
// List for scrolling

import SwiftUI

struct Page3: View {
  var body: some View {
    List {
      ForEach(imageItems) { item in
        HStack {
          ImageThumb(urlString: item.urlStr);
          Text(item.label)
          Spacer()
        }
      }
    }
  }
}

#Preview {
  Page3()
}
