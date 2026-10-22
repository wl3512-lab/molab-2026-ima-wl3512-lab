//
// both photos + the settings live in one @Observable class, handed down with
// .environment like the Order in week 06 iDine

import SwiftUI

@MainActor
@Observable
final class Comparison {
    // changing any of these re-develops both photos
    var before: LoadedPhoto? { didSet { develop() } }
    var after: LoadedPhoto? { didSet { develop() } }
    var look: Look = .original { didSet { develop() } }
    var evenLighting = false { didSet { develop() } }

    var problem: String?

    // what's on screen: the photos with the look applied
    private(set) var beforeImage: UIImage?
    private(set) var afterImage: UIImage?
    // the side-by-side card the share button sends
    private(set) var card: UIImage?

    // nil when either photo is missing or has no date in it
    var daysApart: Int? {
        guard let start = before?.takenAt, let end = after?.takenAt else { return nil }
        return daysBetween(start, end)
    }

    var headline: String {
        switch (before, after) {
        case (nil, nil): return "Pick a before + after"
        case (nil, _): return "Now pick the before"
        case (_, nil): return "Now pick the after"
        default: break
        }
        guard let days = daysApart else { return "No date saved in one of these" }
        switch days {
        case 0: return "Same day"
        case 1: return "1 day apart"
        case 2...: return "\(days) days apart"
        default: return "The after is the older one"
        }
    }

    func swap() {
        (before, after) = (after, before)
    }

    private func develop() {
        beforeImage = before.flatMap { Darkroom.develop($0.image, look: look, evenLighting: evenLighting) }
            .map { UIImage(cgImage: $0) }
        afterImage = after.flatMap { Darkroom.develop($0.image, look: look, evenLighting: evenLighting) }
            .map { UIImage(cgImage: $0) }
        card = makeCard()
    }

    private func makeCard() -> UIImage? {
        guard let beforeImage, let afterImage else { return nil }
        let renderer = ImageRenderer(content: ShareCard(
            before: beforeImage, after: afterImage,
            beforeDate: before?.takenAt, afterDate: after?.takenAt,
            headline: headline
        ))
        // 360pt wide × 3 = a 1080px image, the size Instagram stories want
        renderer.scale = 3
        return renderer.uiImage
    }
}
