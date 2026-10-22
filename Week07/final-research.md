# final project research: HabitaBull

Week07 part 3: *explore WWDC videos and sample code. dream: what's possible only on the phone?*

**the final:** [HabitaBull](https://github.com/wl3512-lab/habitabull-ios), the native iOS version of my lifting web app ([habitabull.vercel.app](https://habitabull.vercel.app)). the plan is to put it on the App Store, not just demo it in class. the web app is the design spec

**what's there now:** a rest timer that sends a lock-screen notification + one buzz when rest is over, and never moves on by itself

**why native at all:** a web app can't buzz on iPhone, can't show anything on the lock screen, can't be started from the Action button, and can't write a workout into Apple Health. all of that is below

## phone-only ideas, each with where to learn it

### 1. rest timer on the Lock Screen + Dynamic Island

you put the phone down between sets. the countdown should be on the lock screen without unlocking

- [Meet ActivityKit](https://developer.apple.com/videos/play/wwdc2023/10184/) (WWDC23)
- [Design dynamic Live Activities](https://developer.apple.com/videos/play/wwdc2023/10194/) (WWDC23)
- sample: [Emoji Rangers: Supporting Live Activities, interactivity, and animations](https://developer.apple.com/documentation/widgetkit/emoji-rangers-supporting-live-activities-interactivity-and-animations)
- article: [Displaying live data with Live Activities](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities)

nice fit: the rest timer already stores a *finish time* (`endsAt`), not a number counting down. a Live Activity can show a countdown to a date by itself (`Text(timerInterval:)`), so the app doesn't have to keep updating it

### 2. log a set + start rest one-handed, without opening the app

the Action button, a Control Center control, an interactive widget, or Siri ("log a set") all run the same App Intent

- [Extend your app's controls across the system](https://developer.apple.com/videos/play/wwdc2024/10157/) (WWDC24): Control Center / Lock Screen / Action button
- [Design App Intents for system experiences](https://developer.apple.com/videos/play/wwdc2024/10176/) (WWDC24)
- [Bring widgets to life](https://developer.apple.com/videos/play/wwdc2023/10028/) (WWDC23): buttons inside widgets + Live Activities
- [Explore new advances in App Intents](https://developer.apple.com/videos/play/wwdc2025/275/) (WWDC25)
- [Develop for Shortcuts and Spotlight with App Intents](https://developer.apple.com/videos/play/wwdc2025/260/) (WWDC25)
- [Bring your app to Siri](https://developer.apple.com/videos/play/wwdc2024/10133/) (WWDC24)

### 3. workouts saved into Apple Health, from the iPhone

an iPhone can run a workout session itself now, not only the Watch

- [Track workouts with HealthKit on iOS and iPadOS](https://developer.apple.com/videos/play/wwdc2025/322/) (WWDC25)
- sample: [Building a workout app for iPhone and iPad](https://developer.apple.com/documentation/healthkit/building-a-workout-app-for-iphone-and-ipad)

### 4. history that works offline in a basement gym

everything stays on the phone, no signal needed. week 06 did this with a JSON file. SwiftData is the bigger version once the history grows

- [Meet SwiftData](https://developer.apple.com/videos/play/wwdc2023/10187/) (WWDC23)
- sample: [Building a document-based app using SwiftData](https://developer.apple.com/documentation/swiftui/building-a-document-based-app-using-swiftdata)

### 5. counting reps with the phone's sensors

- **push-up counter:** phone flat on the floor under your face, the proximity sensor (the one that turns the screen off during calls) fires every time you go down. [`isProximityMonitoringEnabled`](https://developer.apple.com/documentation/uikit/uidevice/isproximitymonitoringenabled). no WWDC video, it's a small API
- **camera rep counting / form check:** Vision finds body joints in each camera frame
  - [Detect Body and Hand Pose with Vision](https://developer.apple.com/videos/play/wwdc2020/10653/) (WWDC20)
  - [Explore 3D body pose and person segmentation in Vision](https://developer.apple.com/videos/play/wwdc2023/111241/) (WWDC23)
  - article: [Detecting Human Body Poses in Images](https://developer.apple.com/documentation/vision/detecting-human-body-poses-in-images)
- motion: [What's new in Core Motion](https://developer.apple.com/videos/play/wwdc2023/10179/) (WWDC23). mostly Watch features, worth a look before deciding

### 6. progress pics that stay private

this week's [Progress Pics](README.md) app is the start. next: a camera with the last progress pic as a see-through ghost, so you stand in the same spot

- [Embed the Photos Picker in your app](https://developer.apple.com/videos/play/wwdc2023/10107/) (WWDC23)
- [Meet the new Photos picker](https://developer.apple.com/videos/play/wwdc2020/10652/) (WWDC20)

### 7. haptics that mean something

one buzz pattern for "rest's over", a different one for a new PR. `sensoryFeedback` already does the simple buzz; Core Haptics does custom patterns

- [Introducing Core Haptics](https://developer.apple.com/videos/play/wwdc2019/520/) (WWDC19)
- sample: [Playing a Custom Haptic Pattern from a File](https://developer.apple.com/documentation/corehaptics/playing-a-custom-haptic-pattern-from-a-file)

## what i think the final should be

core loop first, same as the HabitaBull README plan: today screen → log a set → rest timer (done) → history saved on the phone. then the 2 phone-only extras that help most in the gym:

1. **Live Activity rest timer** (#1): the timer already stores an end date, so it's the shortest path
2. **Action button / Control Center "start rest"** (#2): one-handed, phone stays in your pocket

stretch: push-up counter (#5) or the progress tab (#6)

for the App Store: TestFlight first. HealthKit (#3) needs a privacy explanation and App Review looks closely at health data, so maybe a v1.1 thing

## to watch first

none of these watched yet. starting with **Meet ActivityKit** for #1 (that also checks off "watched at least one WWDC video" on the midterm list), then **Extend your app's controls across the system** for #2

*all video and sample links checked on Oct 22, 2026. research put together with Claude (Anthropic)*
