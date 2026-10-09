//
// the data for the image list page (from 05-ImageEditDemo)
// ItemModel = one row. Document = the whole list + the add / update / delete functions
// it all lives in memory, so it resets when you leave the page (class said next week we save to a file with JSON)

import Foundation

// some picture links to start with
// (renamed from imageArray in the class demo, because my pages 2-8 already use that name)
let photoUrls = [
  "https://tisch.nyu.edu/content/dam/tisch/itp/Faculty/dan-osullivan1.jpg.preset.square.jpeg",
  "https://tisch.nyu.edu/content/dam/tisch/itp/Faculty/Luisa-Pereira.jpg.preset.square.jpeg",
  "https://m.jht1493.net/johnhenrythompson/jt_cu.jpg",
]

// one item in the list
// Identifiable = it has an id, so ForEach can tell the rows apart
struct ItemModel: Identifiable {
  // UUID() = a random id that's never the same twice
  let id = UUID()
  var urlStr: String = ""     // picture from the internet
  var label: String = ""      // the name next to it
  var assetName: String = ""  // picture from Assets (if any)
  var systemName: String = "" // sf symbol drawn on top (if any)
}

// @Observable = when items changes, any view looking at it redraws by itself
@Observable
class Document {
  var items: [ItemModel]

  init() {
    print("Document init")
    // the starting list
    items = [
      ItemModel(urlStr: photoUrls[1], label: "Luisa"),
      ItemModel(urlStr: photoUrls[2], label: "jht", systemName: "rectangle"),
      ItemModel(urlStr: photoUrls[0], label: "dan", systemName: "circle"),
    ]
  }

  // add a new item to the end of the list
  func addItem(urlStr: String, label: String, assetName: String, systemName: String) -> ItemModel {
    let item = ItemModel(urlStr: urlStr, label: label, assetName: assetName, systemName: systemName)
    items.append(item)
    return item
  }

  // find the item with this id and change its stuff
  func updateItem(id: UUID, urlStr: String, label: String, assetName: String, systemName: String) {
    if let index = findIndex(id) {
      items[index].urlStr = urlStr
      items[index].label = label
      items[index].assetName = assetName
      items[index].systemName = systemName
    }
  }

  // find the item with this id and take it out
  func deleteItem(id: UUID) {
    if let index = findIndex(id) {
      items.remove(at: index)
    }
  }

  // which spot in the list has this id? (nil = not found)
  func findIndex(_ id: UUID) -> Int? {
    return items.firstIndex { item in item.id == id }
  }
}
