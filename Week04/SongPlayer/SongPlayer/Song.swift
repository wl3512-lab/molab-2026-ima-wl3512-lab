import AVFoundation // apple's audio/video framework, needed for AVAudioPlayer
import SwiftUI

// one track, file is the mp3 name inside the Audio folder
// Identifiable = lets ForEach / List tell songs apart
// Hashable = lets me compare songs with == and find them in the list
struct Song: Identifiable, Hashable {
  let title: String
  let artist: String
  let file: String // mp3 name without ".mp3"
  let color: Color // used for the cover + button tint
  let symbol: String // SF Symbol name drawn on the cover

  // every song has a different file name so it works as the id
  var id: String { file }

  // finds the mp3 inside the app bundle (the files Xcode packs into the app)
  // it's optional (URL?) because the file might not be there
  var url: URL? {
    Bundle.main.url(forResource: file, withExtension: "mp3")
  }

  // length in seconds, read straight from the mp3
  var length: TimeInterval {
    // guard = bail out early if something's missing
    // try? = if loading the file fails, give nil instead of crashing
    guard let url, let player = try? AVAudioPlayer(contentsOf: url) else { return 0 }
    return player.duration
  }

  // my picks for this week
  // static = belongs to Song itself, so anywhere in the app can say Song.all
  static let all = [
    Song(title: "One More Time", artist: "Daft Punk", file: "one-more-time",
         color: .pink, symbol: "sparkles"),
    Song(title: "Diamonds", artist: "Young Thug ft. Gunna", file: "diamonds",
         color: .cyan, symbol: "suit.diamond.fill"),
    Song(title: "Fractal Chapel", artist: "musicovermind", file: "fractal-chapel",
         color: .purple, symbol: "circle.hexagongrid.fill"),
  ]
}

// 125 seconds -> "2:05"
func timeString(_ seconds: TimeInterval) -> String {
  // the player can give NaN/infinity before a song loads, show 0:00 instead
  guard seconds.isFinite else { return "0:00" }
  // Int() chops off the decimals, max(0, ...) stops negative times
  let total = max(0, Int(seconds))
  // total / 60 = minutes, total % 60 = leftover seconds
  // %02d pads seconds with a 0 so it's "2:05" not "2:5"
  return String(format: "%d:%02d", total / 60, total % 60)
}

// square cover made from the song's color and an SF Symbol
// (no real album art, so I draw one instead)
struct Artwork: View {
  let song: Song
  var size: CGFloat = 52 // default size for the list, page 2 passes a bigger one

  var body: some View {
    // corner radius scales with the size so big and small covers look the same
    RoundedRectangle(cornerRadius: size * 0.2)
      .fill(song.color.gradient) // .gradient = soft built-in gradient of that color
      .frame(width: size, height: size)
      // overlay = draw something on top, centered
      .overlay {
        Image(systemName: song.symbol)
          .font(.system(size: size * 0.4)) // symbol is 40% of the cover
          .foregroundStyle(.white)
      }
  }
}
