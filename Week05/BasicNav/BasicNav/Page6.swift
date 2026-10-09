//
// page 6: same as page 5, but cleaned up into 2 little views i can reuse:
// ItemRow (the row) and ItemDetail (the page you land on)
// no NavigationView here, the home screen's NavigationStack covers it

import SwiftUI

struct Page6: View {
  var body: some View {
    List {
      ForEach(imageArray, id: \.self) { item in
        // destination = where you go, the { } part = what the row looks like
        NavigationLink(
          destination: ItemDetail(item: item)
        )  {
          ItemRow(item: item)
        }
      }
    }
    // title at the top of this page
    .navigationTitle("My Shapes")
  }
}

// the page you land on after tapping a row
struct ItemDetail: View {
  // which shape to show (passed in from the list)
  var item: String
  var body: some View {
    VStack {
      Image(systemName: item)
        .resizable()
        .frame(width:100, height: 100)
      Text(item)
      Spacer()
    }
  }
}

// one row in the list
struct ItemRow: View {
  var item: String
  var body: some View {
    HStack {
      Image(systemName: item)
        .resizable()
        .frame(width:100, height: 100)
      Text(item)
      Spacer()
    }
  }
}

#Preview {
    NavigationStack { Page6() }
}

// https://tisch.nyu.edu/about/directory
