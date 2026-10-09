//
// graphics page: a picture made with code instead of an image file
// uses UIGraphicsImageRenderer (from 03-UIGraphics-View)

import SwiftUI
import UIKit

struct GraphicsView: View {
    var body: some View {
        // prints in the console every time this page redraws (for debugging)
        let _ = Self._printChanges()
        // globe on top, my drawn picture, then big text
        VStack {
            // Image(systemName: "globe")
            // .imageScale(.large)
            // .foregroundColor(.accentColor)
            imageGlobe

            imageBoxes
            
            Text("Hello, world!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.indigo)
        }
        .padding()
    }
    
    // the globe sf symbol, stretched to fit the width
    var imageGlobe: some View {
        Image(systemName: "globe")
//            .imageScale(.large)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.accentColor)
    }
    
    // my drawn picture: 300 wide, 100 tall
    var imageBoxes: some View {
        Image(uiImage: renderGraphics(300, 100))
    }
}

#Preview {
    GraphicsView()
}

// from https://github.com/molab-itp/01-UIRender-playground

// draws the picture and hands it back as a UIImage
func renderGraphics(_ width:Int, _ height:Int) -> UIImage {
    print("renderGraphics width=\(width) height=\(height)")
    // each color bar is a quarter of the width
    let len = width / 4;
    let hi = height;
    let sz = CGSize(width: width, height: height)
    // the "canvas" i draw on
    let renderer = UIGraphicsImageRenderer(size: sz)
    let image = renderer.image { context in
        // 4 bars side by side: pick a color, then fill a rectangle with it
        UIColor.red.setFill()
        context.fill(CGRect(x: 0, y: 0, width: len, height: hi))
        UIColor.green.setFill()
        context.fill(CGRect(x: len, y: 0, width: len, height: hi))
        UIColor.yellow.setFill()
        context.fill(CGRect(x: len*2, y: 0, width: len, height: hi))
        UIColor.black.setFill()
        context.fill(CGRect(x: len*3, y: 0, width: len, height: hi))
        // grey outline around the whole thing
        UIColor.darkGray.setStroke()
        context.stroke(renderer.format.bounds)
        // then 6 more outlines, each one 4 points smaller (insetBy) = nested boxes
        var box = renderer.format.bounds
        for _ in 0...5 {
            box = box.insetBy(dx: 4, dy: 4)
            context.stroke(box)
        }
        // UIColor(red: 158/255, green: 215/255, blue: 245/255, alpha: 1).setFill()
    }
    return image;
}
