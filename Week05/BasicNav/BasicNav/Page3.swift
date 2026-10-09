//
// page 3: same ForEach, but each shape gets its name next to it

import SwiftUI

struct Page3: View {
  var body: some View {
    VStack {
      ForEach(imageArray, id: \.self) { item in
        // picture + name side by side
        HStack {
          Image(systemName: item)
            .resizable()
            .frame(width:100, height: 100)
          Text(item)
          // Spacer = empty space that pushes everything to the left
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
