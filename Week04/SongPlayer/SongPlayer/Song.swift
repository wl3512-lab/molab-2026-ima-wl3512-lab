import AVFoundation
import SwiftUI

// one track, file is the mp3 name inside the Audio folder
struct Song: Identifiable, Hashable {
  let title: String
  let artist: String
  let file: String
  let color: Color
  let symbol: String

  var id: String { file }

  var url: URL? {
    Bundle.main.url(forResource: file, withExtension: "mp3")
  }

  // length in seconds, read straight from the mp3
  var length: TimeInterval {
    guard let url, let player = try? AVAudioPlayer(contentsOf: url) else { return 0 }
    return player.duration
  }

  // my picks for this week
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
  guard seconds.isFinite else { return "0:00" }
  let total = max(0, Int(seconds))
  return String(format: "%d:%02d", total / 60, total % 60)
}

// square cover made from the song's color and an SF Symbol
struct Artwork: View {
  let song: Song
  var size: CGFloat = 52

  var body: some View {
    RoundedRectangle(cornerRadius: size * 0.2)
      .fill(song.color.gradient)
      .frame(width: size, height: size)
      .overlay {
        Image(systemName: song.symbol)
          .font(.system(size: size * 0.4))
          .foregroundStyle(.white)
      }
  }
}
