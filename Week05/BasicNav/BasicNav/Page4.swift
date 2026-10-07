//
// List to allow scrolling for overflow

import SwiftUI

struct Page4: View {
  var body: some View {
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
