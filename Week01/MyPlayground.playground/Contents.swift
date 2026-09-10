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

// ---- output ----------------------------------------------------------------

wave()
print("")
triangle()
print("")
noise(4)
