//
// the edit page: opens already filled in with the item you tapped
// change stuff and tap Update, or Delete it

import SwiftUI

struct UpdateImageView: View {
  // which item this is, so Update / Delete hit the right one
  var id: UUID
  // the boxes start with the item's current stuff (passed in from the list)
  @State var urlStr: String = ""
  @State var label: String = ""
  @State var assetName: String = ""
  @State var systemName: String = ""

  // dismiss = go back to the list
  @Environment(\.dismiss) var dismiss
  // the list, handed down with .environment
  @Environment(Document.self) var document

  var body: some View {
    VStack {
      // live preview, same 3 layers as a row
      ZStack {
        Image(assetName)
          .resizable()
          .aspectRatio(contentMode: .fit)
        AsyncImage(url: URL(string: urlStr)) { phase in
          if let image = phase.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          } else if phase.error != nil {
            Color.red   // bad link
          } else {
            Color.clear // still loading
          }
        }
        Image(systemName: systemName)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
      HStack {
        Button("Update") {
          print("UpdateImageView Update")
          // save the changes into the list, then go back
          document.updateItem(id: id, urlStr: urlStr, label: label,
                              assetName: assetName, systemName: systemName)
          dismiss()
        }
        Spacer()
        Button("Delete") {
          // take it out of the list, then go back
          document.deleteItem(id: id)
          dismiss()
        }
      }
      .padding(10)
      Form {
        TextField("url", text: $urlStr)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
        TextField("label", text: $label)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
        TextField("assetName", text: $assetName)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
        TextField("systemName", text: $systemName)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
      }
    }
  }
}

#Preview {
  UpdateImageView(id: UUID(), urlStr: photoUrls[0], label: "dan")
    .environment(Document())
}
