# Week05 – BasicNav + AppStorage

the BasicNav app from class (missed that day, built it from the class notes), then added `@AppStorage` so it remembers stuff after you close it. then i added every week 5 class demo as its own page, so the whole week lives in one app

## how it's built

- **home:** a `NavigationStack` list, one `NavigationLink` per page: tap a row, the page slides in, back button for free. started from Page9 in [03-ImageUiDemo-1-symbols](https://github.com/molab-itp/03-ImageUiDemo-1-symbols)
- only ONE `NavigationStack`, at the top. i took the `NavigationView` out of pages 5 + 6 (otherwise you get 2 nav bars)
- every file has comments explaining each step

## the pages

**week 3 · shapes** ([03-ImageUiDemo-1-symbols](https://github.com/molab-itp/03-ImageUiDemo-1-symbols))
- 1–4: `VStack`/`HStack`, an array + `ForEach`, `Text` + `Spacer`, `List` so it scrolls
- 5–6: a `NavigationLink` for every shape, then cleaned up into `ItemRow` + `ItemDetail`
- 7: `Toggle`, `Slider`, `Picker` with `@State`
- 8: same as 7 but with `@AppStorage`

**week 3 · graphics:** a picture drawn with code, `UIGraphicsImageRenderer` ([03-UIGraphics-View](https://github.com/molab-itp/03-UIGraphics-View))

**week 4 · audio:** `PlayAudioView` + 3 clips ([04-Audio-State-Demo](https://github.com/molab-itp/04-Audio-State-Demo))

**week 5 · in class**
- **timer:** counts down from 60, uses `@Binding` so the big number view can change the timer's number ([05-TimerDemo](https://github.com/molab-itp/05-TimerDemo))
- **app storage demo:** log in / score that stay saved ([05-AppStorageDemo](https://github.com/molab-itp/05-AppStorageDemo))
- **image list you can edit:** add, change or delete pictures. `@Observable` Document + `.environment`, data only in memory for now ([05-ImageEditDemo](https://github.com/molab-itp/05-ImageEditDemo))
- **heart shape + animation:** my own `Shape` drawn with a `Path`, pulsing with `withAnimation(.repeatForever)` ([05-Heart-Shapes](https://github.com/molab-itp/05-Heart-Shapes))
- **custom font:** `telugu-mn.ttf` listed under `UIAppFonts` in `BasicNav-Info.plist`, used with `Font.custom` ([05-CustomFont](https://github.com/molab-itp/05-CustomFont))

**week 5 · sensors** (CoreMotion, the simulator has no sensors so run these on a phone)
- **bubble level:** tilt the phone, the bubble moves ([05-BubbleLevel](https://github.com/molab-itp/05-BubbleLevel))
- **seismometer:** tap the table, the needle jumps / the graph draws it ([05-Seismometer](https://github.com/molab-itp/05-Seismometer)). the class version used `NavigationSplitView`, mine switches Needle / Graph with a segmented picker because the app already has a NavigationStack

## app storage (part 2)

from [05-AppStorageDemo](https://github.com/molab-itp/05-AppStorageDemo). `@AppStorage` is like `@State` but it saves to `UserDefaults`

- **page 8:** shape, size and fill are saved. pick a hexagon, close the app, open it again, still a hexagon
- **audio:** remembers which sound you picked with "Next"
- **timer + app storage demo:** the time left, username and score are saved too

## things i ran into

- 2 nav bars when a page had its own `NavigationView` inside the home screen's stack
- the image demo and my pages both had an `imageArray` and an `ItemRow`, so i renamed the image demo's to `photoUrls` and `PhotoRow`
- the custom font needs an Info.plist entry, so the project now has `BasicNav-Info.plist`
- `loadBundleAudio` uses `!`, so the app crashes if an audio file isn't in the project
