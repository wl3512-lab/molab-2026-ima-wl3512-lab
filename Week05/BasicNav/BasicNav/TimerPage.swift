//
// timer page (from 05-TimerDemo)
// counts down from 60. the new thing here is @Binding:
// the number lives in TimerPage, and TimeDisplay gets a "remote control" to it

import SwiftUI

struct TimerPage: View {
  // seconds left. @AppStorage so it's still there if i close the app
  // this is the "source of truth" = the one real copy of the number
  @AppStorage("timeRemaining") var timeRemaining = 60

  // is the timer going right now? plain @State, doesn't need saving
  @State var timerIsRunning = false

  // a clock that ticks once a second
  // .autoconnect() = start ticking as soon as the page shows up
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    VStack {
      // $timeRemaining = hand over the binding (the remote control), not just the number,
      // so TimeDisplay is allowed to change it
      TimeDisplay(timeRemaining: $timeRemaining)

      Button {
        // flip on <-> off
        timerIsRunning.toggle()
        // if i just turned it off, go back to 60
        if !timerIsRunning {
          timeRemaining = 60
        }
      } label: {
        // says Start when it's stopped, Reset when it's going
        Text(timerIsRunning ? "Reset" : "Start")
          .font(.system(size: 30))
          .frame(width: 160, height: 60)
          .background(Color.black)
          .foregroundColor(Color.white)
          .cornerRadius(30)
      }
    }
    // this runs every time the clock ticks
    .onReceive(timer) { _ in
      // only count down if it's running and there's time left
      if timeRemaining > 0 && timerIsRunning {
        timeRemaining -= 1
        print("Time Remaining:", timeRemaining)
      }
    }
    // take up the whole screen so it's centered
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationTitle("Timer")
  }
}

// the big number. it doesn't own the time, it borrows it with @Binding
struct TimeDisplay: View {
  // @Binding = a link back to TimerPage's number. change it here and it changes there too
  @Binding var timeRemaining: Int

  var body: some View {
    VStack {
      Text("\(timeRemaining)")
        .font(.system(size: 120))
        // tap the number = +10 seconds (edits TimerPage's number through the binding)
        .onTapGesture {
          timeRemaining += 10
        }
      Text("Tap on time to increase")
        .padding()
    }
  }
}

#Preview {
  NavigationStack { TimerPage() }
}

// from https://github.com/molab-itp/05-TimerDemo
// (which came from https://github.com/mobilelabclass/mobile-lab-timer-kit)
