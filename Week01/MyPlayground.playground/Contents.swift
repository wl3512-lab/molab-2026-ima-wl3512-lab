//: # Week 01 — Text Art
//: Part 2: a playground that produces text art using variables, for-loops and functions.
//: Reference: molab-itp/01-Playground "generative random"

import Foundation

// ---- variables -------------------------------------------------------------

let palette = "░▒▓█"          // light -> dark, so density reads as shading
let width   = 32
let height  = 12

// ---- functions -------------------------------------------------------------

/// Swift strings are not arrays, so a character has to be reached by index.
func charAt(_ s: String, _ offset: Int) -> String {
    String(s[s.index(s.startIndex, offsetBy: offset % s.count)])
}

/// Map 0.0...1.0 onto the palette, dark end last.
func shade(_ t: Double) -> String {
    let i = Int(t * Double(palette.count - 1) + 0.5)
    return charAt(palette, max(0, min(palette.count - 1, i)))
}

// ---- for-loops -------------------------------------------------------------

/// Two sine waves crossing, drawn as density rather than as a line.
func wave() {
    for y in 0..<height {
        var row = ""
        for x in 0..<width {
            let a = sin(Double(x) / 4.0) + sin(Double(y) / 3.0)
            let t = (a + 2.0) / 4.0           // -2...2 -> 0...1
            row += shade(t)
        }
        print(row)
    }
}

/// A triangle, to show the loop bound changing per row.
func triangle() {
    for y in 0..<height {
        var row = ""
        for _ in 0..<y { row += charAt(palette, y) }
        print(row)
    }
}

/// Random band, closest to the class example.
func noise(_ rows: Int) {
    for _ in 0..<rows {
        var row = ""
        for _ in 0..<width { row += charAt(palette, Int.random(in: 0..<palette.count)) }
        print(row)
    }
}

/// Checkerboard, using modulo on the summed coordinates to alternate tone.
func checker(_ block: Int) {
    for y in 0..<height {
        var row = ""
        for x in 0..<width {
            let on = ((x / block) + (y / block)) % 2 == 0
            row += on ? charAt(palette, palette.count - 1) : charAt(palette, 0)
        }
        print(row)
    }
}

/// Concentric ripples: shade by distance from the centre, so tone rings outward.
func ripple() {
    let cx = Double(width) / 2.0
    let cy = Double(height) / 2.0
    let maxD = sqrt(cx * cx + cy * cy)
    for y in 0..<height {
        var row = ""
        for x in 0..<width {
            let dx = Double(x) - cx
            let dy = (Double(y) - cy) * 2.0        // rows are taller than columns, so scale
            let d = sqrt(dx * dx + dy * dy) / maxD
            let t = (sin(d * 12.0) + 1.0) / 2.0    // -1...1 -> 0...1
            row += shade(t)
        }
        print(row)
    }
}

/// A gradient-bordered frame: the edge fades from dark to light around the box.
func frame() {
    for y in 0..<height {
        var row = ""
        for x in 0..<width {
            let onEdge = x == 0 || x == width - 1 || y == 0 || y == height - 1
            if onEdge {
                let t = Double(x + y) / Double(width + height)
                row += shade(t)
            } else {
                row += " "
            }
        }
        print(row)
    }
}

// ---- output ----------------------------------------------------------------

wave()
print("")
triangle()
print("")
noise(4)
print("")
checker(2)
print("")
ripple()
print("")
frame()
