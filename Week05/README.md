# Week05 – BasicNav + AppStorage

the BasicNav app from class (missed that day, built it from the class notes), then added `@AppStorage` so it remembers stuff after you close it

- **home:** a `NavigationStack` list, one link per page. started from Page9 in [03-ImageUiDemo-1-symbols](https://github.com/molab-itp/03-ImageUiDemo-1-symbols)
- **pages 1–8:** the shape pages from that same repo. took the `NavigationView` out of pages 5 + 6 since the home screen already has one (otherwise you get 2 nav bars)
- **graphics:** the `UIGraphicsImageRenderer` view from [03-UIGraphics-View](https://github.com/molab-itp/03-UIGraphics-View)
- **audio:** `PlayAudioView` + 3 clips from [04-Audio-State-Demo](https://github.com/molab-itp/04-Audio-State-Demo)

## app storage (part 2)

from [05-AppStorageDemo](https://github.com/molab-itp/05-AppStorageDemo). `@AppStorage` is like `@State` but it saves to `UserDefaults`

- **page 8:** shape, size and fill are saved. pick a hexagon, close the app, open it again, still a hexagon
- **audio:** remembers which sound you picked with "Next"
