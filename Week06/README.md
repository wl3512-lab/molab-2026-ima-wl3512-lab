# Week06 – iDine

the iDine restaurant app from class, cloned from [molab-itp/06-iDine](https://github.com/molab-itp/06-iDine). it's the [Hacking with Swift SwiftUI tutorial](https://www.hackingwithswift.com/quick-start/swiftui/swiftui-tutorial-building-a-complete-project) ([twostraws/iDine](https://github.com/twostraws/iDine)), updated in class to use `@Observable` instead of `ObservableObject`

open `iDine/iDine.xcodeproj` in Xcode

## what's in it

- **Model:** `MenuSection` (the menu, loaded from `menu.json` with `Bundle-decode.swift`) + `Order` (the shared order)
- **Views:** `ContentView` (menu list), `ItemRow`, `ItemDetail`, `OrderView`, `CheckoutView`
- `MainView` holds the tabs: menu + order
