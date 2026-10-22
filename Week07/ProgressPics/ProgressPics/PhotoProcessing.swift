//
// the photo work: open a photo, read when it was taken, put a look on it.
// no UIKit or SwiftUI in here on purpose, so Week07/checks can compile this
// file on the Mac and test it without a simulator

import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import ImageIO

struct LoadedPhoto {
    let image: CGImage
    // when the photo was taken, from the photo's own EXIF data. nil if it has none
    // (screenshots, some downloads, photos sent through some chat apps)
    let takenAt: Date?
}

enum PhotoLoader {
    // phone photos are 12–48 MP. shrinking both to this keeps the filters fast
    static let maxPixels = 1600

    static func load(_ data: Data) -> LoadedPhoto? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            // turns the photo upright using its orientation tag, otherwise a
            // portrait mirror pic can come in sideways
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixels,
        ]
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any]
        return LoadedPhoto(image: image, takenAt: takenAt(properties))
    }

    static func takenAt(_ properties: [CFString: Any]?) -> Date? {
        let exif = properties?[kCGImagePropertyExifDictionary] as? [CFString: Any]
        let tiff = properties?[kCGImagePropertyTIFFDictionary] as? [CFString: Any]
        // DateTimeOriginal = when the shutter went. the TIFF date is a fallback
        guard let text = exif?[kCGImagePropertyExifDateTimeOriginal] as? String
            ?? tiff?[kCGImagePropertyTIFFDateTime] as? String else { return nil }
        return exifDate.date(from: text)
    }

    // EXIF dates look like "2026:10:17 07:42:10", in the phone's local time
    static let exifDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        return formatter
    }()
}

// counts calendar days, so 11pm monday → 7am tuesday is 1 day, not 0.
// negative means `end` is the older photo
func daysBetween(_ start: Date, _ end: Date, calendar: Calendar = .current) -> Int {
    let from = calendar.startOfDay(for: start)
    let to = calendar.startOfDay(for: end)
    return calendar.dateComponents([.day], from: from, to: to).day ?? 0
}

// the same look goes on both photos, so the only difference left is you
enum Look: String, CaseIterable, Identifiable {
    case original, mono, noir, sepia

    var id: Self { self }
    var name: String { rawValue.capitalized }

    func apply(to image: CIImage) -> CIImage {
        switch self {
        case .original:
            return image
        case .mono:
            let filter = CIFilter.photoEffectMono()
            filter.inputImage = image
            return filter.outputImage ?? image
        case .noir:
            let filter = CIFilter.photoEffectNoir()
            filter.inputImage = image
            return filter.outputImage ?? image
        case .sepia:
            let filter = CIFilter.sepiaTone()
            filter.inputImage = image
            filter.intensity = 0.8
            return filter.outputImage ?? image
        }
    }
}

enum Darkroom {
    // making a CIContext is slow, so there's one for the whole app (same as Instafilter)
    static let context = CIContext()

    // "even out lighting" runs Core Image's auto-enhance on each photo before the
    // look, so a dark basement-gym pic and a bright bathroom-mirror pic end up
    // closer. it fixes each photo on its own, it doesn't copy one onto the other
    static func develop(_ photo: CGImage, look: Look, evenLighting: Bool) -> CGImage? {
        var image = CIImage(cgImage: photo)
        if evenLighting {
            for filter in image.autoAdjustmentFilters(options: [.redEye: false]) {
                filter.setValue(image, forKey: kCIInputImageKey)
                image = filter.outputImage ?? image
            }
        }
        image = look.apply(to: image)
        return context.createCGImage(image, from: image.extent)
    }
}
