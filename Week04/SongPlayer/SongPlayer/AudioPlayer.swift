import AVFoundation // AVAudioPlayer + AVAudioSession live here
import SwiftUI

// wraps AVAudioPlayer so the views can see what's playing and how far in it is
// it's a class (not a struct) so both pages share the same one
// NSObject + AVAudioPlayerDelegate = so the player can tell me when a song ends
// ObservableObject = views watching it redraw when an @Published value changes
class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
  @Published var song: Song? // what's loaded right now, nil before you tap anything
  @Published var isPlaying = false
  @Published var currentTime: TimeInterval = 0 // seconds into the song
  @Published var duration: TimeInterval = 0 // how long the song is

  // private = only this class can touch these
  private var player: AVAudioPlayer? // the thing that actually plays the mp3
  private var timer: Timer? // ticks to update currentTime

  // load a song and start it from the top, or just keep going if it's already loaded
  func play(_ newSong: Song) {
    // same song you're already on? don't restart it, just unpause if needed
    if newSong == song {
      if !isPlaying { resume() }
      return
    }
    // find the mp3, stop here if it's missing
    guard let url = newSong.url else {
      print("missing mp3:", newSong.file)
      return
    }
    // do / catch because these calls can throw errors
    do {
      // .playback so it still plays with the silent switch on
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true)
      // make a new player for this file
      player = try AVAudioPlayer(contentsOf: url)
      player?.delegate = self // send "song finished" to this class
      song = newSong
      duration = player?.duration ?? 0 // ?? 0 = use 0 if player is nil
      currentTime = 0
      resume()
    } catch {
      print("could not play", newSong.file, error)
    }
  }

  // start or unpause
  func resume() {
    player?.play()
    isPlaying = true
    startTimer()
  }

  // pause and stop the timer so it's not ticking for nothing
  func pause() {
    player?.pause()
    isPlaying = false
    timer?.invalidate()
  }

  // one button for both: if playing then pause, else play
  func togglePlay() {
    isPlaying ? pause() : resume()
  }

  // jump to a spot in the song, the slider calls this when you let go
  func seek(to time: TimeInterval) {
    player?.currentTime = time
    currentTime = time
  }

  // move through the list, wraps around at both ends
  // offset 1 = next, -1 = previous
  func skip(by offset: Int) {
    // need a current song and its spot in the list, otherwise do nothing
    guard let song, let index = Song.all.firstIndex(of: song) else { return }
    let count = Song.all.count
    // % count wraps around: next after the last song goes back to the first
    // + count stops it going negative when you hit back on the first song
    play(Song.all[(index + offset + count) % count])
  }

  // ticks 4 times a second so the progress bar moves
  private func startTimer() {
    timer?.invalidate() // kill any old timer so there's never two
    // [weak self] so the timer doesn't keep this object alive forever
    timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
      guard let self, let player = self.player else { return }
      // copy the real position into currentTime, which makes the views redraw
      self.currentTime = player.currentTime
    }
  }

  // when a song ends roll straight into the next one
  // (AVAudioPlayer calls this by itself because I set delegate = self)
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    skip(by: 1)
  }
}
