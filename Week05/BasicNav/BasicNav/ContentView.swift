//
// home screen: a list of every page, tap one to open it
// started from Page9 in 03-ImageUiDemo-1-symbols

import SwiftUI

struct ContentView: View {
    var body: some View {
        // NavigationStack = the thing that lets you tap a row and slide to a new page
        // it's the newer NavigationView. i only need ONE, up here at the top,
        // so none of the pages inside get their own (otherwise you get 2 nav bars)
        NavigationStack {
            // List = scrolling rows, like the settings app
            List {
                // Section = a group of rows with a little header on top
                Section("week 3 · shapes (03-ImageUiDemo-1-symbols)") {
                    // NavigationLink("row text") { page } = tap the row and that page slides in,
                    // the back button comes for free
                    NavigationLink("1. VStack + HStack") { Page1() }
                    NavigationLink("2. array + ForEach") { Page2() }
                    NavigationLink("3. ForEach + Text + Spacer") { Page3() }
                    NavigationLink("4. List (scrolls)") { Page4() }
                    NavigationLink("5. a link for each shape") { Page5() }
                    NavigationLink("6. ItemRow + ItemDetail") { Page6() }
                    NavigationLink("7. Toggle, Slider, Picker") { Page7() }
                    NavigationLink("8. same, but remembered") { Page8() }
                }
                Section("week 3 · graphics (03-UIGraphics-View)") {
                    NavigationLink("UIGraphicsImageRenderer") { GraphicsView() }
                }
                Section("week 4 · audio (04-Audio-State-Demo)") {
                    NavigationLink("play audio") { PlayAudioView() }
                }
                // everything we did in class week 5
                Section("week 5 · in class") {
                    NavigationLink("timer (@Binding)") { TimerPage() }
                    NavigationLink("app storage demo") { AppStorageDemoPage() }
                    NavigationLink("image list you can edit") { ImageEditPage() }
                    NavigationLink("heart shape + animation") { HeartPulseView() }
                    NavigationLink("custom font") { FontPage() }
                }
                // these need the phone's motion sensors, so try them on a real phone
                Section("week 5 · sensors (run on your phone)") {
                    NavigationLink("bubble level") { BubbleLevelPage() }
                    NavigationLink("seismometer") { SeismometerPage() }
                }
            }
            // big title at the top of the home screen
            .navigationTitle("BasicNav")
        }
    }
}

#Preview {
    ContentView()
}
