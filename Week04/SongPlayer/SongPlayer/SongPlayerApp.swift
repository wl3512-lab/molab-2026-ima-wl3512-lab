import SwiftUI

// app starts here, one audio player shared by both pages
@main
struct SongPlayerApp: App {
  @StateObject private var audio = AudioPlayer()

  var body: some Scene {
    WindowGroup {
      SongListView()
        .environmentObject(audio)
    }
  }
}
