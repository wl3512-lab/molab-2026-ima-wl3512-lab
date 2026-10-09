//
// the "Add Item" page: type a link / name / sf symbol, see a preview, tap Add

import SwiftUI

struct AddImageView: View {
  // what's typed in each box. @State because they change as you type
  @State var urlStr: String = ""
  @State var label: String = ""
  @State var assetName: String = ""
  @State var systemName: String = ""

  // dismiss = close this page and go back
  @Environment(\.dismiss) var dismiss
  // the list, handed down from ImageEditPage with .environment
  @Environment(Document.self) var document

  var body: some View {
    VStack {
      // the preview, same 3 layers as a row
      ZStack {
        Image(assetName)
          .resizable()
          .aspectRatio(contentMode: .fit)
        // AsyncImage = loads a picture from a link by itself
        AsyncImage(url: URL(string: urlStr)) { phase in
          if let image = phase.image {
            // it loaded
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          } else if phase.error != nil {
            // bad link = red box
            Color.red
          } else {
            // still loading = nothing
            Color.clear
          }
        }
        Image(systemName: systemName)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
      HStack {
        Button("Add") {
          print("AddImageView Add")
          // put it in the list (let _ = i don't need what it gives back)
          let _ = document.addItem(urlStr: urlStr, label: label,
                                   assetName: assetName, systemName: systemName)
          // and go back to the list
          dismiss()
        }
        Spacer()
        Button("Cancel") {
          print("AddImageView Cancel")
          dismiss()
        }
      }
      .padding(10)
      // Form = the grey settings-style boxes. $ = the box types straight into the variable
      Form {
        TextField("url", text: $urlStr)
          .textInputAutocapitalization(.never) // links shouldn't get a capital letter
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
  AddImageView()
    .environment(Document())
}
