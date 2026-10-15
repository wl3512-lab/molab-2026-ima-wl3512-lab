//
//  Order.swift
//  iDine
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

@Observable
class Order {
    // This also catches the Order screen's direct array deletion.
    var items = [MenuItem]() {
        didSet {
            saveOrder()
        }
    }

    var storageError: String?

    private var saveURL: URL {
        URL.documentsDirectory.appending(path: "order.json")
    }

    init() {
        do {
            let data = try Data(contentsOf: saveURL)
            // Initializing the property here does not trigger its didSet.
            items = try JSONDecoder().decode([MenuItem].self, from: data)
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
            // A first launch has no saved order yet.
        } catch {
            storageError = "The saved order could not be loaded. Its file has been left in place."
            print("Could not load order: \(error)")
        }
    }

    private func saveOrder() {
        do {
            let data = try JSONEncoder().encode(items)
            // Replace the file only after the new data has been written.
            try data.write(to: saveURL, options: .atomic)
            storageError = nil
        } catch {
            storageError = "These changes could not be saved. Keep the app open and try again."
            print("Could not save order: \(error)")
        }
    }

    var total: Int {
        if items.count > 0 {
            return items.reduce(0) { $0 + $1.price }
        } else {
            return 0
        }
    }

    func add(item: MenuItem) {
        items.append(item)
    }

    func remove(item: MenuItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
}
