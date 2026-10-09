//
// image list you can edit (from 05-ImageEditDemo)
// a list of pictures: tap one to change or delete it, "Add Item" to make a new one
// this is navigation again: every row is a NavigationLink to an edit page

import SwiftUI

struct ImageEditPage: View {
  // the page owns the list. @State keeps it around while i'm on this page
  @State private var document = Document()

  var body: some View {
    // no NavigationStack here, the home screen already has one
    List {
      // reversed() = newest first, so the thing you just added is at the top
      ForEach(document.items.reversed()) { item in
        NavigationLink {
          // tap a row -> the edit page, already filled in with this item's stuff
          UpdateImageView(id: item.id,
                          urlStr: item.urlStr,
                          label: item.label,
                          assetName: item.assetName,
                          systemName: item.systemName)
            // hand the list to the edit page so it can change it
            .environment(document)
        } label: {
          PhotoRow(item: item)
        }
      }
    }
    .navigationTitle("My Items")
    // a button up in the top right corner
    .toolbar {
      NavigationLink("Add Item") {
        AddImageView()
          .environment(document)
      }
    }
  }
}

#Preview {
  NavigationStack { ImageEditPage() }
}

// from https://github.com/molab-itp/05-ImageEditDemo
// changed: NavigationView -> no nav here (home has the stack), navigationBarItems -> .toolbar,
// ItemRow -> PhotoRow and imageArray -> photoUrls so the names don't clash with page 6 + page 2
