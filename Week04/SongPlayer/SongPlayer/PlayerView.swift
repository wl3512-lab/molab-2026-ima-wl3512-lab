import SwiftUI

// page 2: now playing, cover + progress bar + controls
struct PlayerView: View {
  // same shared player as page 1
  @EnvironmentObject var audio: AudioPlayer
  // the song you tapped on page 1
  let song: Song

  // slider position, kept separate so the timer doesn't fight you while dragging
  @State private var scrubTime: TimeInterval = 0
  @State private var isScrubbing = false // true while your finger is on the slider

  // after skipping, show whatever the player moved on to
  // (?? song = fall back to the tapped song if nothing's loaded yet)
  var shown: Song { audio.song ?? song }

  var body: some View {
    // everything stacked top to bottom with 28pt gaps
    VStack(spacing: 28) {
      Spacer() // Spacers top and bottom keep it centered

      // big cover with a glow in the song's color
      Artwork(song: shown, size: 260)
        .shadow(color: shown.color.opacity(0.5), radius: 24, y: 12)
        // shrinks a bit when paused, full size when playing
        .scaleEffect(audio.isPlaying ? 1 : 0.85)
        // animate that size change with a little bounce
        .animation(.spring(duration: 0.4), value: audio.isPlaying)

      VStack(spacing: 4) {
        Text(shown.title).font(.title.bold())
        Text(shown.artist).foregroundStyle(.secondary)
      }

      // progress bar + times
      VStack(spacing: 6) {
        // $scrubTime = the slider reads AND writes this value
        // range is 0 to the song length (max(..., 1) so it's never 0...0 before loading)
        Slider(value: $scrubTime, in: 0...max(audio.duration, 1)) { editing in
          // this runs when you start and stop dragging
          isScrubbing = editing
          // finger lifted -> actually jump the song to that spot
          if !editing { audio.seek(to: scrubTime) }
        }
        HStack {
          Text(timeString(scrubTime)) // time played
          Spacer()
          Text("-" + timeString(audio.duration - scrubTime)) // time left
        }
        .font(.caption.monospacedDigit())
        .foregroundStyle(.secondary)
      }

      // back / play-pause / next
      HStack(spacing: 48) {
        Button {
          audio.skip(by: -1) // previous song
        } label: {
          Image(systemName: "backward.fill")
        }
        Button {
          audio.togglePlay()
        } label: {
          // big circle icon that flips between play and pause
          Image(systemName: audio.isPlaying ? "pause.circle.fill" : "play.circle.fill")
            .font(.system(size: 72))
        }
        Button {
          audio.skip(by: 1) // next song
        } label: {
          Image(systemName: "forward.fill")
        }
      }
      .font(.title) // size for the back/next icons

      Spacer()
    }
    .padding(.horizontal, 32)
    .tint(shown.color) // slider + buttons use the song's color
    .navigationBarTitleDisplayMode(.inline) // small title bar, no big header
    // start the song as soon as this page opens
    .onAppear { audio.play(song) }
    // every time the timer updates currentTime, move the slider along...
    .onChange(of: audio.currentTime) { _, time in
      // ...unless you're dragging it, then leave it where your finger is
      if !isScrubbing { scrubTime = time }
    }
  }
}

// preview needs a NavigationStack + its own player to show up in Xcode's canvas
#Preview {
  NavigationStack {
    PlayerView(song: Song.all[0])
  }
  .environmentObject(AudioPlayer())
}
