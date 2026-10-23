# [08-CameraRecorder](https://github.com/molab-itp/08-CameraRecorder)

- apply core image filters to live video stream from camera
- record button to save video to Photo library
- minminal @Observable Model
- no need for Combine!

## Building and troubleshooting

Open `CaptureRecorder.xcodeproj`, select the `CaptureRecorder` scheme and an
iPhone simulator, then choose **Product > Build**. To verify from this directory:

```sh
xcodebuild -project CaptureRecorder.xcodeproj \
  -scheme CaptureRecorder -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

On October 23, 2026, Xcode reported
`Could not compute dependency graph: Failed to receive dependency graph response`
during build preparation, before compiling Swift. Retrying both from the command
line and with **Product > Build** in Xcode succeeded without source changes.
This points to a temporary Xcode build-service failure; this project has no
external package dependencies. If it recurs, quit and reopen Xcode, then retry.
If necessary, use **Product > Clean Build Folder** before building again.

The initial successful build also flagged the deprecated `videoOrientation`
API. The camera connection now checks support before setting a portrait
`videoRotationAngle` of 90 degrees, following
[Apple's capture connection API](https://developer.apple.com/documentation/avfoundation/avcaptureconnection/videorotationangle).

Use a physical iPhone to check the live camera, filters, recording and saving to
Photos; a simulator build does not verify camera capture.

## Plan

- slider for filter param

## Sources

- mainly claude.ai with alot of debugging
- preview using FrameView from [08-FilterTheWorld](https://github.com/mobilelabclass-itp/08-FilterTheWorld)

## CoreImageFilterReference documentation

- [CoreImageFilterReference ref](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html)
  -- list each filter and their parameters

## Changes

- Detailed research
  - [CaptureRecorder](https://github.com/jht9629-nyu/CaptureRecorder.git)
- added app icon
- in ContentView re-org FilterSelectionView, RecordButtonView

```
func FilterSelectionView() -> some View {}
func RecordButtonView() -> some View {}
```

- moved MovieRecorder to z-archived

## Notes

```
2026-10-20 21:44:54
in 08-CameraRecorder
replace ObservableObject with @Observable macro

in 08-CameraRecorder
is now Observable, does it variables like currentEffect
need to be marked ignored
since it was not affecting swiftui
when ObservableObject was used

   var currentEffect: VideoEffect = .normal

add @ObservationIgnored to match previous behavior

>> delete unused CameraPreviewView.swift
>> rename from MovieRecorder to CaptureRecorder
>> created new project and copied source files

>> need fix permissions:

This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.

This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data.

>> chatgpt.com -- fail
>> claude.a -- fail
>> how to fix xcode project permissions issue: This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.
>> this is not Info.plist
>> now in project settings

>> Add second privacy photo setting
```

## video-recorder-with-effects-1.swift

- Movie recorded successfully
- reduced effect to 3
-
- fail: effects not applied
- fail: during effect, buttons shoved off screen
- fail: effect preview affects layout

```
>> https://chatgpt.com/c/67da0189-fe58-8002-8790-e60a12121373
>> fix orientation of context.createCGImage

>> Added startRecording_asset from MovieRecordTest

>> FrameView
>> from: [08-FilterTheWorld](https://github.com/mobilelabclass-itp/08-FilterTheWorld)
```

## filtered-video-recorder-app.swift

In AVFoundation AVCaptureSession AVCaptureFileOutputRecordingDelegate correctly apply filters to sample in captureOutput
privide a swiftui app example of this
nothing recorded

## video-recorder-with-effects-2.swift

Crash on record

## video-recorder-with-effects-3.swift

Crash - no video preview

## Details

- https://claude.ai/chat/a6a7974f-915e-461a-b566-635b2ff08929

```
swiftui code to record movie with video effect applied to each frame

code gives the following error: "Initializer for conditional binding must have Optional type, not 'CIImage'" on line "let ciImage = CIImage(cvPixelBuffer: pixelBuffer) else { return }"

This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.

This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data.

This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSMicrophoneUsageDescription key with a string value explaining to the user how the app uses this data.

>> Compiles

>> Crash on record:

Thread 1: "\*\*\* -[AVCaptureMovieFileOutput startRecordingToOutputFileURL:recordingDelegate:] No active/enabled connections"

>> Filters not applied

Initializer for conditional binding must have Optional type, not 'CIImage'

    guard let ciImage = CIImage(cvPixelBuffer: pixelBuffer) else {
      CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
      return
    }

>> New crash

**_ Terminating app due to uncaught exception 'NSGenericException', reason: '_** -[AVCaptureSession startRunning] startRunning may not be called between calls to beginConfiguration and commitConfiguration'
```

## rename in xcode is hell!
