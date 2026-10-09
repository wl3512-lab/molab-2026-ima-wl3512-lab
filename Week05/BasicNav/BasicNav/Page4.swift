//
// page 4: same as page 3 but in a List, so it scrolls
// (page 3 runs off the bottom of the screen and you can't see the rest)

import SwiftUI

struct Page4: View {
  var body: some View {
    // List instead of VStack = scrolling rows
    List {
      ForEach(imageArray, id: \.self) { item in
        HStack {
          Image(systemName: item)
            .resizable()
            .frame(width:100, height: 100)
          Text(item)
          Spacer()
        }
      }
    }
  }
}

#Preview {
    Page4()
}

// https://tisch.nyu.edu/about/directory
