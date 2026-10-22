import SwiftUI

@main
struct ProgressPicsApp: App {
    // made once here and shared with every view through .environment
    @State private var compare = Comparison()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(compare)
                #if DEBUG
                .task { ScreenshotHook.load(into: compare) }
                #endif
        }
    }
}
