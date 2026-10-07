//
// home screen: a list of every page, tap one to open it
// started from Page9 in 03-ImageUiDemo-1-symbols

import SwiftUI

struct ContentView: View {
    var body: some View {
        // NavigationStack is the newer NavigationView. one stack here,
        // so the pages inside don't need their own
        NavigationStack {
            List {
                Section("shapes · 03-ImageUiDemo-1-symbols") {
                    NavigationLink("1. VStack + HStack") { Page1() }
                    NavigationLink("2. array + ForEach") { Page2() }
                    NavigationLink("3. ForEach + Text + Spacer") { Page3() }
                    NavigationLink("4. List (scrolls)") { Page4() }
                    NavigationLink("5. a link for each shape") { Page5() }
                    NavigationLink("6. ItemRow + ItemDetail") { Page6() }
                    NavigationLink("7. Toggle, Slider, Picker") { Page7() }
                    NavigationLink("8. same, but remembered") { Page8() }
                }
                Section("graphics · 03-UIGraphics-View") {
                    NavigationLink("UIGraphicsImageRenderer") { GraphicsView() }
                }
                Section("audio · 04-Audio-State-Demo") {
                    NavigationLink("play audio") { PlayAudioView() }
                }
            }
            .navigationTitle("BasicNav")
        }
    }
}

#Preview {
    ContentView()
}
