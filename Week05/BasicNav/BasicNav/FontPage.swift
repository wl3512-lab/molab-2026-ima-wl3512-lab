//
// custom font (from 05-CustomFont)
// 3 steps to use a font that isn't built into the phone:
// 1. drag the font file (telugu-mn.ttf) into the project
// 2. list it in Info.plist under UIAppFonts ("Fonts provided by application")
//    -> mine is BasicNav-Info.plist, next to the project file
// 3. use it with Font.custom("Its PostScript Name", size:)
//    (find the postscript name: open the font in Font Book -> Font Info)

import SwiftUI

struct FontPage: View {
  var body: some View {
    VStack(spacing: 20) {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      // my custom font
      Text("Q Hello, Telugu MN!")
        .font(Font.custom("Telugu MN", size: 38))
      // the normal system font, so you can compare
      Text("Q Hello, system!")
        .font(.system(size: 54))
    }
    .padding()
    .navigationTitle("Custom font")
  }
}

#Preview {
  NavigationStack { FontPage() }
}

// from https://github.com/molab-itp/05-CustomFont
// https://developer.apple.com/documentation/swiftui/applying-custom-fonts-to-text/
