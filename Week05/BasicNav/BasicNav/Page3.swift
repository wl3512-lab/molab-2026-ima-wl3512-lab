//
// ForEach Text Spacer

import SwiftUI

struct Page3: View {
  var body: some View {
    VStack {
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
    Page3()
}

// https://tisch.nyu.edu/about/directory
