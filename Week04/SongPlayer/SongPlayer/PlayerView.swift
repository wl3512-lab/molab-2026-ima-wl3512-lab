import SwiftUI

// page 2: now playing, cover + progress bar + controls
struct PlayerView: View {
  @EnvironmentObject var audio: AudioPlayer
  let song: Song

  // slider position, kept separate so the timer doesn't fight you while dragging
  @State private var scrubTime: TimeInterval = 0
  @State private var isScrubbing = false

  // after skipping, show whatever the player moved on to
  var shown: Song { audio.song ?? song }

  var body: some View {
    VStack(spacing: 28) {
      Spacer()

      Artwork(song: shown, size: 260)
        .shadow(color: shown.color.opacity(0.5), radius: 24, y: 12)
        .scaleEffect(audio.isPlaying ? 1 : 0.85)
        .animation(.spring(duration: 0.4), value: audio.isPlaying)

      VStack(spacing: 4) {
        Text(shown.title).font(.title.bold())
        Text(shown.artist).foregroundStyle(.secondary)
      }

      VStack(spacing: 6) {
        Slider(value: $scrubTime, in: 0...max(audio.duration, 1)) { editing in
          isScrubbing = editing
          if !editing { audio.seek(to: scrubTime) }
        }
        HStack {
          Text(timeString(scrubTime))
          Spacer()
          Text("-" + timeString(audio.duration - scrubTime))
        }
        .font(.caption.monospacedDigit())
        .foregroundStyle(.secondary)
      }

      HStack(spacing: 48) {
        Button {
          audio.skip(by: -1)
        } label: {
          Image(systemName: "backward.fill")
        }
        Button {
          audio.togglePlay()
        } label: {
          Image(systemName: audio.isPlaying ? "pause.circle.fill" : "play.circle.fill")
            .font(.system(size: 72))
        }
        Button {
          audio.skip(by: 1)
        } label: {
          Image(systemName: "forward.fill")
        }
      }
      .font(.title)

      Spacer()
    }
    .padding(.horizontal, 32)
    .tint(shown.color)
    .navigationBarTitleDisplayMode(.inline)
    .onAppear { audio.play(song) }
    .onChange(of: audio.currentTime) { _, time in
      if !isScrubbing { scrubTime = time }
    }
  }
}

#Preview {
  NavigationStack {
    PlayerView(song: Song.all[0])
  }
  .environmentObject(AudioPlayer())
}
