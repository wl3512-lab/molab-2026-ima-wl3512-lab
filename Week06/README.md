# Week06 – iDine + Router

two apps from class this week

## iDine

the iDine restaurant app, cloned from [molab-itp/06-iDine](https://github.com/molab-itp/06-iDine). it's the [Hacking with Swift SwiftUI tutorial](https://www.hackingwithswift.com/quick-start/swiftui/swiftui-tutorial-building-a-complete-project) ([twostraws/iDine](https://github.com/twostraws/iDine)), updated in class to use `@Observable` instead of `ObservableObject`

open `iDine/iDine.xcodeproj` in Xcode

- **Model:** `MenuSection` (the menu, loaded from `menu.json` with `Bundle-decode.swift`) + `Order` (the shared order)
- **Views:** `ContentView` (menu list), `ItemRow`, `ItemDetail`, `OrderView`, `CheckoutView`
- `MainView` holds the tabs: menu + order

## Router

cloned from [molab-itp/06-Router](https://github.com/molab-itp/06-Router). switching pages without `NavigationView`: a `PageModel` (`@Observable` class) remembers which page you're on, and buttons at the bottom change it. based on [03-ImageUiDemo-2-urls](https://github.com/molab-itp/03-ImageUiDemo-2-urls)

open `Router/Router.xcodeproj` in Xcode

- `RouterApp` makes one `PageModel` and hands it down with `.environment`
- `MainView` reads it with `@Environment`, a `switch` on `pageTag` shows Page1, Page3 or Page5, and the `[Page1] [Page3] [Page5]` buttons set it (the one you're on is bold)
- Page1: image from a URL · Page2: `Item` struct · Page3: `List` · Page4: `ItemRow` + `ItemDetail` · Page5: local image + `Toggle`, `Slider`, `Picker`
