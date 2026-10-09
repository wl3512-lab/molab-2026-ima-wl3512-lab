//
// the app starts here

import SwiftUI

// @main = the front door. ios runs this first when the app opens
@main
struct BasicNavApp: App {
    var body: some Scene {
        // one window, and the first thing in it is my home screen (ContentView)
        WindowGroup {
            ContentView()
        }
    }
}
