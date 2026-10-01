import SwiftUI

// page 1: the playlist, tap a song to open the player
struct SongListView: View {
  // grabs the shared player that SongPlayerApp passed down
  @EnvironmentObject var audio: AudioPlayer

  // adds up every song's length for the footer
  // reduce starts at 0 and adds each song's length: $0 = running total, $1 = next song
  var totalLength: TimeInterval {
    Song.all.reduce(0) { $0 + $1.length }
  }

  var body: some View {
    // NavigationStack = lets you push to page 2 and get a back button for free
    NavigationStack {
      List {
        // Section so I can put a footer under the songs
        Section {
          // one row per song
          ForEach(Song.all) { song in
            // NavigationLink = tapping the row opens page 2 with this song
            NavigationLink {
              PlayerView(song: song)
            } label: {
              // only show the speaker icon if this exact song is playing
              SongRow(song: song, isPlaying: audio.isPlaying && audio.song == song)
            }
          }
        } footer: {
          // "3 songs · 14:43"
          Text("\(Song.all.count) songs · \(timeString(totalLength))")
        }
      }
      .navigationTitle("Week04 Mix")
      // safeAreaInset = sticks something to the bottom without covering the list
      .safeAreaInset(edge: .bottom) {
        // only show the mini player once a song has been picked
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
    // HStack = side by side
    HStack(spacing: 14) {
      Artwork(song: song)
      // VStack = stacked, .leading = lined up on the left
      VStack(alignment: .leading, spacing: 2) {
        Text(song.title).font(.headline)
        Text(song.artist).font(.subheadline).foregroundStyle(.secondary) // grey
      }
      Spacer() // pushes everything after it to the right edge
      if isPlaying {
        Image(systemName: "speaker.wave.2.fill")
          .foregroundStyle(song.color)
          .symbolEffect(.variableColor.iterative) // makes the sound waves animate
      }
      Text(timeString(song.length))
        .font(.subheadline.monospacedDigit()) // every number same width so they line up
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
        // "1:23 / 5:20", updates every timer tick
        Text(timeString(audio.currentTime) + " / " + timeString(audio.duration))
          .font(.caption.monospacedDigit())
          .foregroundStyle(.secondary)
      }
      Spacer()
      Button {
        audio.togglePlay()
      } label: {
        // icon flips between pause and play
        Image(systemName: audio.isPlaying ? "pause.fill" : "play.fill")
          .font(.title2)
      }
      .tint(song.color) // button takes the song's color
    }
    .padding(12)
    // frosted glass look with rounded corners
    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    .padding(.horizontal)
  }
}

// preview in Xcode's canvas, needs its own player since there's no app running
#Preview {
  SongListView()
    .environmentObject(AudioPlayer())
}
