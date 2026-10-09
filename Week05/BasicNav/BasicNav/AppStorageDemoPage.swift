//
// app storage demo (from 05-AppStorageDemo)
// @AppStorage = like @State, but it saves to the phone (UserDefaults)
// log in or change the score, close the app, open it again = still there

import SwiftUI

struct AppStorageDemoPage: View {
  // the name in quotes is the key it's saved under on the phone
  // the part after = is what you get the very first time, before anything's saved
  @AppStorage("username") var username: String = "JHT"
  @AppStorage("score") var score: Int = 0

  var body: some View {
    VStack(spacing: 16) {
      Spacer()
      // \( ) = put the variable inside the text
      Text("Welcome, \(username)")
      HStack {
        // changing username also saves it, i don't have to do anything else
        Button("Log in") { username = "someone" }
        Button("Log out") { username = "Anonymous" }
      }
      Text("Score \(score)")
      HStack {
        Button("+ Score") { score += 1 }
        Button("- Score") { score -= 1 }
      }
      Spacer()
    }
    // bordered = the buttons get a little grey box so you can tell they're buttons
    .buttonStyle(.bordered)
    .navigationTitle("App storage")
  }
}

#Preview {
  NavigationStack { AppStorageDemoPage() }
}

// from https://github.com/molab-itp/05-AppStorageDemo
