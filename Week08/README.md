# Week08: Ghost Cam

[Assignment: Video Media](https://github.com/molab-itp/content-2026-ima/blob/main/weeks/08_video.md#homework-week08)

a camera that leaves motion trails. wave your hand or spin around and you smear across the screen like a ghost, and a pink slider sets how long the trails hang around. hit record and the trails are in the saved video too. it's built on the class [08-CameraRecorder](https://github.com/molab-itp/08-CameraRecorder) (Core Image filters on the live camera + record to Photos). my twist is the **Ghost** effect. it's basically TouchDesigner's Feedback TOP, but on the phone

## run it

1. open `CameraRecorder/CaptureRecorder.xcodeproj` in Xcode
2. plug in your iPhone, pick it as the run target, **⌘R** (the simulator has no camera)
3. allow camera + Photos
4. tap **Ghost** in the filter bar, then move. drag the slider: left = no trail, right = long smeary trails
5. tap the record button, move around, tap it again. the clip lands in Photos

## how the ghost works

every frame gets mixed with the frame that was on screen just before it:

```
new picture = this frame × (1 − trail) + last picture × trail
```

with trail at 0.85, each frame keeps 85% of the last picture, so anything that moves fades out over about a second. anything that holds still just looks normal

- the mix is Core Image's `CIDissolveTransition` (it's meant for crossfading two images; `time` is how far toward the second image you go). that fit the class code exactly: the class app already looks up a filter by name for each effect and sets its inputs in a `switch`, so Ghost is one more `case`
- `lastFrame` is made from the finished `CGImage`, not from the filter output. a `CIImage` is only a recipe, nothing is drawn until the context renders it. if i kept the recipe, every frame's recipe would contain every earlier frame's recipe and the app would choke within seconds. turning it into real pixels each frame cuts that chain
- the slider is bound straight to `model.trail` (`$model.trail`). `Model` is `@Observable`, so it just works like a `@State`
- recording goes through the same `filterImage` function as the preview, so the trails end up in the saved video without any extra code

| file | what changed |
| --- | --- |
| `Model.swift` | `trail` (slider value) and `lastFrame` (the picture from the frame before) |
| `Model-filterImage.swift` | `Ghost` effect → `CIDissolveTransition`, mixed with `lastFrame`; `lastFrame` saved after each render |
| `ContentView.swift` | pink trail slider, only shows while Ghost is on |

the rest is the class app. my notes from getting it running (the build-service error, the deprecated rotation API) are in [CameraRecorder/README.md](CameraRecorder/README.md#building-and-troubleshooting)

## checks

- builds for the iPhone 17 Pro simulator with no errors (Oct 28)
- not checked yet: running it on my phone and recording a ghost clip. the simulator can't test the camera

## part 1

past-week folders: Week01–Week07 are all there already, nothing missing. wiki page updated with week 08

## final project research

HabitaBull is still the final. research so far: [Week07/final-research.md](../Week07/final-research.md). Live Activity rest timer first, then an Action button "start rest". this week added one idea: a form-check camera for a set (set timer burned into the video), using the same record-with-a-filter code as this app

## sources / AI assistance

- based on [molab-itp/08-CameraRecorder](https://github.com/molab-itp/08-CameraRecorder) by jht, with `FrameView` from [08-FilterTheWorld](https://github.com/molab-itp/08-FilterTheWorld)
- [CIDissolveTransition](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIDissolveTransition) in the Core Image Filter Reference
- Claude (Anthropic), October 28, 2026 wrote the code help and this README
