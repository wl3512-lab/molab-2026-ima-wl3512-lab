//
// audio page: plays sound clips that live inside the app (from 04-Audio-State-Demo)
// @State = the player, TimelineView = redraws constantly so the time ticks up
// @AppStorage remembers which sound you picked, even after closing the app

import SwiftUI
import AVFoundation

// the 3 clips in my Audio folder
let bundleAudio = [
    "bbc-birds-1.m4a",
    "bbc-birds-2.m4a",
    "scale-1.m4a"
];

// make an audio player for one of the clips inside the app
// heads up: the ! crashes the app if the file isn't actually in the project

func loadBundleAudio(_ fileName:String) -> AVAudioPlayer? {
    // find the file inside the app
    let path = Bundle.main.path(forResource: fileName, ofType:nil)!
    let url = URL(fileURLWithPath: path)
    // try to make the player, print the error if it doesn't work
    do {
        return try AVAudioPlayer(contentsOf: url)
    } catch {
        print("loadBundleAudio error", error)
    }
    return nil
}

struct PlayAudioView: View {
    // which clip (0, 1 or 2). saved, so it's the same one next time you open the app
    @AppStorage("soundIndex") private var soundIndex = 0
    // the file name for that clip (% = wrap around so it never goes past the end)
    private var soundFile: String { bundleAudio[soundIndex % bundleAudio.count] }
    // the player. nil until you hit Play
    @State private var player: AVAudioPlayer? = nil
    var body: some View {
        // TimelineView(.animation) = redraw every frame, so currentTime counts up live
        TimelineView(.animation) { context in
            VStack {
                HStack {
                    // load the clip, loop it forever (-1), play
                    Button("Play") {
                        print("Button Play")
                        player = loadBundleAudio(soundFile)
                        print("player", player as Any)
                        // Loop indefinitely
                        player?.numberOfLoops = -1
                        player?.play()
                    }
                    Button("Stop") {
                        print("Button Stop")
                        player?.stop()
                    }
                    // go to the next clip (wraps back to 0 after the last one)
                    Button("Next") {
                        soundIndex = (soundIndex+1) % bundleAudio.count
                    }
                }
                Text("soundIndex \(soundIndex)")
                Text("soundFile \(soundFile)")
                // only show the times once there's a player
                if let player = player {
                    Text("duration " + String(format: "%.1f", player.duration))
                    Text("currentTime " + String(format: "%.1f", player.currentTime))
                }
            }
        }
    }
}

#Preview {
    PlayAudioView()
}

// https://developer.apple.com/documentation/avfaudio/avaudioplayer

// https://developer.apple.com/documentation/swiftui/state

// Source for audio clips
// https://www.youraccompanist.com/free-scales-and-warm-ups/reference-scales
// Reference Scales_On A Flat-G Sharp.mp3
// https://sound-effects.bbcrewind.co.uk/search?cat=Animals
// https://file-examples.com/index.php/sample-audio-files/sample-mp3-download/
