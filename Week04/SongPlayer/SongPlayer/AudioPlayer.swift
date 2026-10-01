import AVFoundation
import SwiftUI

// wraps AVAudioPlayer so the views can see what's playing and how far in it is
class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
  @Published var song: Song?
  @Published var isPlaying = false
  @Published var currentTime: TimeInterval = 0
  @Published var duration: TimeInterval = 0

  private var player: AVAudioPlayer?
  private var timer: Timer?

  // load a song and start it from the top, or just keep going if it's already loaded
  func play(_ newSong: Song) {
    if newSong == song {
      if !isPlaying { resume() }
      return
    }
    guard let url = newSong.url else {
      print("missing mp3:", newSong.file)
      return
    }
    do {
      // .playback so it still plays with the silent switch on
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true)
      player = try AVAudioPlayer(contentsOf: url)
      player?.delegate = self
      song = newSong
      duration = player?.duration ?? 0
      currentTime = 0
      resume()
    } catch {
      print("could not play", newSong.file, error)
    }
  }

  func resume() {
    player?.play()
    isPlaying = true
    startTimer()
  }

  func pause() {
    player?.pause()
    isPlaying = false
    timer?.invalidate()
  }

  func togglePlay() {
    isPlaying ? pause() : resume()
  }

  // jump to a spot in the song, the slider calls this when you let go
  func seek(to time: TimeInterval) {
    player?.currentTime = time
    currentTime = time
  }

  // move through the list, wraps around at both ends
  func skip(by offset: Int) {
    guard let song, let index = Song.all.firstIndex(of: song) else { return }
    let count = Song.all.count
    play(Song.all[(index + offset + count) % count])
  }

  // ticks 4 times a second so the progress bar moves
  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
      guard let self, let player = self.player else { return }
      self.currentTime = player.currentTime
    }
  }

  // when a song ends roll straight into the next one
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    skip(by: 1)
  }
}
