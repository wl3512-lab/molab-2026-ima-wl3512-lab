import CoreImage
import Foundation
import ImageIO
import UniformTypeIdentifiers

// Runs the app's real PhotoProcessing.swift against JPEGs made here, in memory.
// Breaking the date reading, the upright turn, the downscale, or a look must fail here.
@main
struct PhotoChecks {
    static var passed = 0

    static func main() {
        do {
            try run()
            print("all \(passed) photo checks passed")
        } catch {
            print(error)
            exit(1)
        }
    }

    static func run() throws {
        // dates: EXIF DateTimeOriginal is read, a photo without one gives nil
        let dated = try jpeg(width: 400, height: 300, exifDate: "2026:08:31 07:15:00")
        let datedPhoto = try unwrap(PhotoLoader.load(dated), "a dated JPEG opens")
        let expected = DateComponents(calendar: .current, year: 2026, month: 8, day: 31, hour: 7, minute: 15).date
        try check(datedPhoto.takenAt == expected, "DateTimeOriginal becomes takenAt in local time")

        let undated = try jpeg(width: 400, height: 300)
        try check(PhotoLoader.load(undated)?.takenAt == nil, "a photo with no date gives nil, not today's date")
        try check(PhotoLoader.load(Data("not a photo".utf8)) == nil, "data that isn't an image is refused")

        // orientation tag 6 = the camera was turned sideways. the pixels are stored
        // 400x300 but the photo is meant to be shown 300x400
        let sideways = try jpeg(width: 400, height: 300, orientation: 6)
        let upright = try unwrap(PhotoLoader.load(sideways), "a sideways JPEG opens")
        try check(upright.image.width == 300 && upright.image.height == 400, "orientation tag turns the photo upright")

        // a 12 MP-sized photo is shrunk so the longest side is maxPixels
        let big = try jpeg(width: 4032, height: 3024)
        let shrunk = try unwrap(PhotoLoader.load(big), "a 12 MP-sized JPEG opens")
        try check(max(shrunk.image.width, shrunk.image.height) == PhotoLoader.maxPixels,
                  "big photos are shrunk to \(PhotoLoader.maxPixels)px on the long side")
        try check(abs(Double(shrunk.image.width) / Double(shrunk.image.height) - 4032.0 / 3024.0) < 0.01,
                  "shrinking keeps the shape of the photo")

        // calendar days, in New York so the clock change on Nov 1 2026 is covered
        var newYork = Calendar(identifier: .gregorian)
        newYork.timeZone = TimeZone(identifier: "America/New_York")!
        func at(_ m: Int, _ d: Int, _ h: Int) -> Date {
            DateComponents(calendar: newYork, year: 2026, month: m, day: d, hour: h).date!
        }
        try check(daysBetween(at(10, 19, 23), at(10, 20, 7), calendar: newYork) == 1, "11pm → 7am next day counts as 1 day")
        try check(daysBetween(at(10, 20, 7), at(10, 20, 23), calendar: newYork) == 0, "same day counts as 0")
        try check(daysBetween(at(8, 31, 9), at(10, 17, 9), calendar: newYork) == 47, "Aug 31 → Oct 17 is 47 days")
        try check(daysBetween(at(10, 31, 12), at(11, 2, 12), calendar: newYork) == 2, "the Nov 1 clock change doesn't skew the count")
        try check(daysBetween(at(10, 17, 9), at(8, 31, 9), calendar: newYork) == -47, "after older than before comes out negative")

        // looks: same size out, original untouched, mono/noir are gray, sepia changes color
        let red = try unwrap(PhotoLoader.load(try jpeg(width: 64, height: 64, color: (0.9, 0.2, 0.2))), "a red JPEG opens")
        let source = pixel(red.image)
        for look in Look.allCases {
            let out = try unwrap(Darkroom.develop(red.image, look: look, evenLighting: false), "\(look.name) develops")
            try check(out.width == 64 && out.height == 64, "\(look.name) keeps the photo size")
            let p = pixel(out)
            switch look {
            case .original:
                try check(close(p, source, within: 2), "Original leaves the photo alone")
            case .mono, .noir:
                try check(abs(p.r - p.g) <= 2 && abs(p.g - p.b) <= 2, "\(look.name) turns red into gray")
            case .sepia:
                try check(!close(p, source, within: 10) && p.r >= p.g && p.g >= p.b, "Sepia turns red into a warm brown")
            }
        }

        // even out lighting: a dark photo comes out brighter, a bright one doesn't get darker
        // than it started by much. the photos are gradients so auto-enhance has something to read
        let dark = try unwrap(PhotoLoader.load(try jpeg(width: 256, height: 256, gradient: (0.02, 0.25))), "a dark JPEG opens")
        let evened = try unwrap(Darkroom.develop(dark.image, look: .original, evenLighting: true), "even out lighting develops")
        let before = brightness(dark.image), after = brightness(evened)
        try check(after > before + 5, "even out lighting brightens a dark photo (\(Int(before)) → \(Int(after)) of 255)")
    }

    // MARK: test photos, made with ImageIO so no files are needed

    static func jpeg(width: Int, height: Int, exifDate: String? = nil, orientation: Int? = nil,
                     color: (Double, Double, Double) = (0.6, 0.5, 0.4), gradient: (Double, Double)? = nil) throws -> Data {
        let space = CGColorSpace(name: CGColorSpace.sRGB)!
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
                                space: space, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
        if let (low, high) = gradient {
            let colors = [CGColor(gray: low, alpha: 1), CGColor(gray: high, alpha: 1)] as CFArray
            let fade = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.genericGrayGamma2_2)!, colors: colors, locations: nil)!
            context.drawLinearGradient(fade, start: .zero, end: CGPoint(x: width, y: height), options: [])
        } else {
            context.setFillColor(CGColor(srgbRed: color.0, green: color.1, blue: color.2, alpha: 1))
            context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        }
        let image = context.makeImage()!

        var properties: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality: 0.95]
        if let exifDate {
            properties[kCGImagePropertyExifDictionary] = [kCGImagePropertyExifDateTimeOriginal: exifDate]
        }
        if let orientation {
            properties[kCGImagePropertyOrientation] = orientation
        }
        let data = NSMutableData()
        let destination = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(destination, image, properties as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { throw CheckFailure(message: "could not write a test JPEG") }
        return data as Data
    }

    // MARK: reading pixels back

    struct RGB { let r: Int, g: Int, b: Int }

    // the middle pixel, as 0–255 sRGB
    static func pixel(_ image: CGImage) -> RGB {
        let bytes = draw(image, width: 1, height: 1)
        return RGB(r: Int(bytes[0]), g: Int(bytes[1]), b: Int(bytes[2]))
    }

    // average brightness, 0–255
    static func brightness(_ image: CGImage) -> Double {
        let bytes = draw(image, width: 32, height: 32)
        var total = 0.0
        for i in stride(from: 0, to: bytes.count, by: 4) {
            total += 0.299 * Double(bytes[i]) + 0.587 * Double(bytes[i + 1]) + 0.114 * Double(bytes[i + 2])
        }
        return total / Double(bytes.count / 4)
    }

    static func draw(_ image: CGImage, width: Int, height: Int) -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: width * height * 4)
        let context = CGContext(data: &bytes, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4,
                                space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
        context.interpolationQuality = .medium
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return bytes
    }

    static func close(_ a: RGB, _ b: RGB, within limit: Int) -> Bool {
        abs(a.r - b.r) <= limit && abs(a.g - b.g) <= limit && abs(a.b - b.b) <= limit
    }

    // MARK: tiny check helpers

    struct CheckFailure: Error, CustomStringConvertible {
        let message: String
        var description: String { "FAILED: \(message)" }
    }

    static func check(_ condition: Bool, _ message: String) throws {
        guard condition else { throw CheckFailure(message: message) }
        passed += 1
        print("ok - \(message)")
    }

    static func unwrap<T>(_ value: T?, _ message: String) throws -> T {
        guard let value else { throw CheckFailure(message: message) }
        return value
    }
}
