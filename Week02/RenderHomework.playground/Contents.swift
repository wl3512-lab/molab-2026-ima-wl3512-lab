//claude helped me deploy in repo

import UIKit

let dim = 2000.0
let renderer = UIGraphicsImageRenderer(size: CGSize(width: dim, height: dim))

let image = renderer.image { context in
    let ctx = context.cgContext
    let box = renderer.format.bounds

    // background
    UIColor(red: 0.1, green: 0.05, blue: 0.1, alpha: 1).setFill()
    context.fill(box)

    // grid of circles
    let cells = 8
    let cell = dim / Double(cells)
    for row in 0..<cells {
        for col in 0..<cells {
            let size = cell * Double.random(in: 0.3...0.9)
            let offset = (cell - size) / 2
            let x = Double(col) * cell + offset
            let y = Double(row) * cell + offset
            UIColor(hue: Double.random(in: 0.75...1.0), saturation: 0.8,
                    brightness: 1, alpha: 0.8).setFill()
            ctx.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
        }
    }

    // SF Symbol sparkle
    let symbol = UIImage(systemName: "sparkles")!
        .withTintColor(.white, renderingMode: .alwaysOriginal)
    let s = dim * 0.4
    symbol.draw(in: CGRect(x: (dim - s) / 2, y: (dim - s) / 2, width: s, height: s))

    // 4. text
    let font = UIFont.boldSystemFont(ofSize: 64)
    let text = NSAttributedString(string: "lucy liu",
        attributes: [.font: font, .foregroundColor: UIColor.white])
    text.draw(at: CGPoint(x: 40, y: dim - 110))
}

image

// save as a png
let data = image.pngData()
let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let filePath = folder.appendingPathComponent("week02.png")
try? data?.write(to: filePath)
print("cp \(filePath.path) ~/Downloads/.")
