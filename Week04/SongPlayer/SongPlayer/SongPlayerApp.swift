import SwiftUI

// app starts here, one audio player shared by both pages
@main // tells swift this is where the app launches
struct SongPlayerApp: App {
  // @StateObject makes the player once and keeps it alive the whole time the app runs
  // (if it was made inside a view it could get thrown away and the music would stop)
  @StateObject private var audio = AudioPlayer()

  var body: some Scene {
    // WindowGroup = the app's main window
    WindowGroup {
      // page 1 is the first thing you see
      SongListView()
        // hands the same player to every view below this one,
        // so page 1 and page 2 both control the same music
        .environmentObject(audio)
    }
  }
}
