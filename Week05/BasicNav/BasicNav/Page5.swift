//
// page 5: every row is a link. tap a shape -> its own page
// no NavigationView here, the home screen's NavigationStack covers it

import SwiftUI

struct Page5: View {
  var body: some View {
    List {
      ForEach(imageArray, id: \.self) { item in
        NavigationLink {
          // where you go when you tap: the shape big, with its name
          VStack {
            Image(systemName: item)
              .resizable()
              .frame(width:100, height: 100)
            Text(item)
            Spacer()
          }
        } label: {
          // what the row looks like in the list
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
}

#Preview {
    NavigationStack { Page5() }
}

// https://tisch.nyu.edu/about/directory
