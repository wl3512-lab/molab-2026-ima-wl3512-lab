import SwiftUI

// main screen, one tab for each drawing experiment
struct MainView: View {
  var body: some View {
    TabView {
      TenPrintView()
        .tabItem { Label("10 Print", systemImage: "number") }
      RandomArtView()
        .tabItem { Label("Circles", systemImage: "circle.grid.3x3.fill") }
      CanvasAnimView()
        .tabItem { Label("Animated", systemImage: "play.circle") }
      ContentView()
        .tabItem { Label("Shapes", systemImage: "square.on.circle") }
    }
  }
}

#Preview {
  MainView()
}
