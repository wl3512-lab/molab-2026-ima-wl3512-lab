//
// debug builds only. lets a script fill both slots from files so the README
// screenshots don't need someone tapping through the photo picker:
//
//   SIMCTL_CHILD_SHOT_BEFORE=/path/a.jpg SIMCTL_CHILD_SHOT_AFTER=/path/b.jpg \
//     xcrun simctl launch booted edu.nyu.wl3512.ProgressPics
//
// optional: SHOT_LOOK=mono|noir|sepia, SHOT_EVEN=1, SHOT_CARD=/path/card.png
// (writes the share card there). does nothing when the variables aren't set

#if DEBUG
import SwiftUI

enum ScreenshotHook {
    @MainActor static func load(into compare: Comparison) {
        let env = ProcessInfo.processInfo.environment
        guard let before = env["SHOT_BEFORE"], let after = env["SHOT_AFTER"] else { return }

        compare.before = (try? Data(contentsOf: URL(fileURLWithPath: before))).flatMap(PhotoLoader.load)
        compare.after = (try? Data(contentsOf: URL(fileURLWithPath: after))).flatMap(PhotoLoader.load)
        if let look = env["SHOT_LOOK"].flatMap(Look.init(rawValue:)) {
            compare.look = look
        }
        compare.evenLighting = env["SHOT_EVEN"] == "1"

        if let path = env["SHOT_CARD"], let png = compare.card?.pngData() {
            try? png.write(to: URL(fileURLWithPath: path))
        }
    }
}
#endif
