//
// one screen: the comparison on top, everything you tap at the bottom where
// your thumb is (same rule as HabitaBull's rest timer)

import PhotosUI
import SwiftUI

struct ContentView: View {
    @Environment(Comparison.self) private var compare

    // PhotosPicker runs outside the app, so it doesn't need permission to the
    // whole library. only the 2 photos you pick ever reach this app
    @State private var beforeItem: PhotosPickerItem?
    @State private var afterItem: PhotosPickerItem?
    @State private var sideBySide = false

    var body: some View {
        @Bindable var compare = compare

        NavigationStack {
            VStack(spacing: 14) {
                HStack {
                    Text(compare.headline)
                        .font(.title2.bold())
                    Spacer()
                    if let days = compare.daysApart, days < 0 {
                        Button("Swap", systemImage: "arrow.left.arrow.right", action: compare.swap)
                    }
                }

                photos
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if let problem = compare.problem {
                    Text(problem)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Picker("View", selection: $sideBySide) {
                    Text("Slide").tag(false)
                    Text("Side by side").tag(true)
                }
                .pickerStyle(.segmented)

                Picker("Look", selection: $compare.look) {
                    ForEach(Look.allCases) { look in
                        Text(look.name).tag(look)
                    }
                }
                .pickerStyle(.segmented)

                Toggle("Even out lighting", isOn: $compare.evenLighting)

                HStack(spacing: 12) {
                    PhotoSlot(title: "Before", image: compare.beforeImage, date: compare.before?.takenAt, item: $beforeItem)
                    PhotoSlot(title: "After", image: compare.afterImage, date: compare.after?.takenAt, item: $afterItem)
                }
            }
            .padding()
            .navigationTitle("Progress Pics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if let card = compare.card {
                    let image = Image(uiImage: card)
                    ShareLink(item: image, preview: SharePreview("Progress pics", image: image))
                }
            }
            .onChange(of: beforeItem) { load(beforeItem, into: \.before) }
            .onChange(of: afterItem) { load(afterItem, into: \.after) }
        }
    }

    @ViewBuilder private var photos: some View {
        if let before = compare.beforeImage, let after = compare.afterImage {
            if sideBySide {
                HStack(spacing: 6) {
                    FilledPhoto(image: before, label: "BEFORE")
                        .aspectRatio(3 / 4, contentMode: .fit)
                    FilledPhoto(image: after, label: "AFTER")
                        .aspectRatio(3 / 4, contentMode: .fit)
                }
            } else {
                CompareSlider(before: before, after: after)
                    .aspectRatio(3 / 4, contentMode: .fit)
            }
        } else {
            ContentUnavailableView(
                "No progress pics yet",
                systemImage: "figure.strengthtraining.traditional",
                description: Text("Pick a before and an after below. They stay on your phone.")
            )
        }
    }

    // same idea as Instafilter's loadImage, but for either slot
    private func load(_ item: PhotosPickerItem?, into slot: ReferenceWritableKeyPath<Comparison, LoadedPhoto?>) {
        guard let item else { return }
        Task {
            // opening a 12 MP photo takes a moment, so it happens off the main
            // thread and the screen doesn't freeze while it does
            if let data = try? await item.loadTransferable(type: Data.self),
               let photo = await Task.detached(operation: { PhotoLoader.load(data) }).value {
                compare[keyPath: slot] = photo
                compare.problem = nil
            } else {
                compare.problem = "Couldn't open that photo. Try another one."
            }
        }
    }
}

// a big tappable button with a thumbnail and the date the photo was taken
struct PhotoSlot: View {
    let title: String
    let image: UIImage?
    let date: Date?
    @Binding var item: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $item, matching: .images) {
            HStack(spacing: 10) {
                Group {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .font(.title3)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.quaternary)
                    }
                }
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, minHeight: 52)
        }
        .buttonStyle(.bordered)
    }

    private var subtitle: String {
        guard image != nil else { return "tap to pick" }
        return date?.formatted(date: .abbreviated, time: .omitted) ?? "no date"
    }
}

#Preview {
    ContentView()
        .environment(Comparison())
}
