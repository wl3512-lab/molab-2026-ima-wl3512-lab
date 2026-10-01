import SwiftUI

// page 1: the playlist, tap a song to open the player
struct SongListView: View {
  @EnvironmentObject var audio: AudioPlayer

  var totalLength: TimeInterval {
    Song.all.reduce(0) { $0 + $1.length }
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          ForEach(Song.all) { song in
            NavigationLink {
              PlayerView(song: song)
            } label: {
              SongRow(song: song, isPlaying: audio.isPlaying && audio.song == song)
            }
          }
        } footer: {
          Text("\(Song.all.count) songs · \(timeString(totalLength))")
        }
      }
      .navigationTitle("Week04 Mix")
      .safeAreaInset(edge: .bottom) {
        if let song = audio.song {
          MiniPlayer(song: song)
        }
      }
    }
  }
}

// one line in the list: cover, name, artist, length
struct SongRow: View {
  let song: Song
  let isPlaying: Bool

  var body: some View {
    HStack(spacing: 14) {
      Artwork(song: song)
      VStack(alignment: .leading, spacing: 2) {
        Text(song.title).font(.headline)
        Text(song.artist).font(.subheadline).foregroundStyle(.secondary)
      }
      Spacer()
      if isPlaying {
        Image(systemName: "speaker.wave.2.fill")
          .foregroundStyle(song.color)
          .symbolEffect(.variableColor.iterative)
      }
      Text(timeString(song.length))
        .font(.subheadline.monospacedDigit())
        .foregroundStyle(.secondary)
    }
  }
}

// small bar pinned to the bottom so you can pause without opening the player
struct MiniPlayer: View {
  @EnvironmentObject var audio: AudioPlayer
  let song: Song

  var body: some View {
    HStack(spacing: 12) {
      Artwork(song: song, size: 40)
      VStack(alignment: .leading, spacing: 2) {
        Text(song.title).font(.subheadline.bold())
        Text(timeString(audio.currentTime) + " / " + timeString(audio.duration))
          .font(.caption.monospacedDigit())
          .foregroundStyle(.secondary)
      }
      Spacer()
      Button {
        audio.togglePlay()
      } label: {
        Image(systemName: audio.isPlaying ? "pause.fill" : "play.fill")
          .font(.title2)
      }
      .tint(song.color)
    }
    .padding(12)
    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    .padding(.horizontal)
  }
}

#Preview {
  SongListView()
    .environmentObject(AudioPlayer())
}
