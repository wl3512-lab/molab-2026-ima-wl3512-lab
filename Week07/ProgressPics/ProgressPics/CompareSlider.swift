//
// drag anywhere on the photo to move the line. left of the line is before,
// right of it is after. both photos fill the same frame so they line up

import SwiftUI

struct CompareSlider: View {
    let before: UIImage
    let after: UIImage

    // its own @State, so dragging only redraws this view and not the whole screen
    @State private var split = 0.5

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width

            ZStack(alignment: .leading) {
                FilledPhoto(image: after, label: "AFTER", labelSide: .topTrailing)
                // the before photo sits on top, cut off at the line
                FilledPhoto(image: before, label: "BEFORE")
                    .mask(alignment: .leading) {
                        Rectangle().frame(width: width * split)
                    }

                Rectangle()
                    .fill(.white)
                    .frame(width: 3)
                    .overlay {
                        Circle()
                            .fill(.white)
                            .frame(width: 34, height: 34)
                            .overlay {
                                Image(systemName: "arrow.left.and.right")
                                    .font(.caption.bold())
                                    .foregroundStyle(.black)
                            }
                    }
                    .shadow(radius: 3)
                    .offset(x: width * split - 1.5)
            }
            .contentShape(Rectangle())
            // minimumDistance 0 so a tap jumps the line there too
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        split = min(max(drag.location.x / width, 0), 1)
                    }
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        // VoiceOver: swipe up/down to move the line
        .accessibilityElement()
        .accessibilityLabel("Before and after comparison")
        .accessibilityValue("\(Int(split * 100)) percent before")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: split = min(split + 0.1, 1)
            case .decrement: split = max(split - 0.1, 0)
            @unknown default: break
            }
        }
    }
}

// a photo that fills its frame (cropping the edges, never stretching) with a label
struct FilledPhoto: View {
    let image: UIImage
    let label: String
    var labelSide: Alignment = .topLeading

    var body: some View {
        Color.clear
            .overlay {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            .overlay(alignment: labelSide) {
                Text(label)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.55), in: Capsule())
                    .foregroundStyle(.white)
                    .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
