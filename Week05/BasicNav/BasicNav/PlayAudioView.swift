//
// Audio bundled with app
// @State to track variables that affect UI
// TimelineView for timer triggered updates
// Keep audio short
// @AppStorage remembers which sound you picked, even after closing the app

import SwiftUI
import AVFoundation

let bundleAudio = [
    "bbc-birds-1.m4a",
    "bbc-birds-2.m4a",
    "scale-1.m4a"
];

// Create a Audio Player given a file stored in the app bundle
// Detailed documntation on AVAudioPlayer
//  https://developer.apple.com/documentation/avfaudio/avaudioplayer

func loadBundleAudio(_ fileName:String) -> AVAudioPlayer? {
    let path = Bundle.main.path(forResource: fileName, ofType:nil)!
    let url = URL(fileURLWithPath: path)
    do {
        return try AVAudioPlayer(contentsOf: url)
    } catch {
        print("loadBundleAudio error", error)
    }
    return nil
}

struct PlayAudioView: View {
    @AppStorage("soundIndex") private var soundIndex = 0
    private var soundFile: String { bundleAudio[soundIndex % bundleAudio.count] }
    @State private var player: AVAudioPlayer? = nil
    var body: some View {
        TimelineView(.animation) { context in
            VStack {
                HStack {
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
                    Button("Next") {
                        soundIndex = (soundIndex+1) % bundleAudio.count
                    }
                }
                Text("soundIndex \(soundIndex)")
                Text("soundFile \(soundFile)")
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
