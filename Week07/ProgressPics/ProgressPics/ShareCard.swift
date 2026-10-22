//
// the picture the share button sends: both photos side by side with their dates.
// ImageRenderer turns this view into a UIImage (see Comparison.makeCard)

import SwiftUI

struct ShareCard: View {
    let before: UIImage
    let after: UIImage
    let beforeDate: Date?
    let afterDate: Date?
    let headline: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(headline)
                .font(.title2.bold())
            HStack(spacing: 8) {
                column("Before", before, beforeDate)
                column("After", after, afterDate)
            }
            Text("HabitaBull · progress pics")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(width: 360)
        .background(.white)
        .foregroundStyle(.black)
        // the card should look the same even if the phone is in dark mode
        .environment(\.colorScheme, .light)
    }

    private func column(_ title: String, _ image: UIImage, _ date: Date?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 213)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(title)
                .font(.headline)
            Text(date?.formatted(date: .abbreviated, time: .omitted) ?? "no date")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
