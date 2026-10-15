import Foundation

// Runs the real Order and MenuItem models against files in a temporary home.
// Removing autosave, startup loading, or saving an empty order must fail here.
@main
struct OrderPersistenceChecks {
    static func main() {
        do {
            try run()
        } catch {
            print(error)
            exit(1)
        }
    }

    static func run() throws {
        let expectedHome = URL(fileURLWithPath: CommandLine.arguments[1])
        let documents = URL.documentsDirectory
        guard documents.resolvingSymlinksInPath().path == expectedHome.appending(path: "Documents").resolvingSymlinksInPath().path else {
            throw CheckFailure(message: "Refusing to run outside the temporary test home")
        }
        try FileManager.default.createDirectory(at: documents, withIntermediateDirectories: true)
        let saveURL = documents.appending(path: "order.json")

        let meal = MenuItem(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            name: "Test pasta", photoCredit: "Test fixture", price: 12,
            restrictions: ["V"], description: "A fixture, not a menu change."
        )
        let drink = MenuItem(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            name: "Test juice", photoCredit: "Test fixture", price: 3,
            restrictions: [], description: "A second fixture."
        )

        let firstLaunch = Order()
        try check(firstLaunch.items.isEmpty, "first launch without a file starts empty")
        firstLaunch.add(item: meal)
        let secondLaunch = Order()
        try check(secondLaunch.items.map(\.name) == ["Test pasta"] && secondLaunch.total == 12,
                  "a newly created order restores the saved food and total")

        firstLaunch.add(item: meal)
        firstLaunch.add(item: drink)
        let restored = Order()
        try check(restored.items.map(\.name) == ["Test pasta", "Test pasta", "Test juice"] && restored.total == 27,
                  "duplicate food and item order survive reload")

        restored.items.remove(at: 1)
        try check(Order().items.map(\.name) == ["Test pasta", "Test juice"] && Order().total == 15,
                  "direct list deletion is saved")
        restored.remove(item: meal)
        try check(Order().items.map(\.name) == ["Test juice"], "model deletion is saved")
        restored.items.removeAll()
        try check(Order().items.isEmpty && String(data: Data(contentsOf: saveURL), encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) == "[]",
                  "deleting the last item saves an empty order")

        let damagedData = Data("not valid JSON".utf8)
        try damagedData.write(to: saveURL)
        try check(Order().items.isEmpty, "a damaged file does not crash startup")
        try check(Data(contentsOf: saveURL) == damagedData, "startup leaves a damaged file available for inspection")
        print("All 8 persistence checks passed.")
    }

    static func check(_ condition: @autoclosure () throws -> Bool, _ message: String) throws {
        guard try condition() else { throw CheckFailure(message: "FAIL: \(message)") }
        print("PASS: \(message)")
    }

    struct CheckFailure: Error, CustomStringConvertible {
        let message: String
        var description: String { message }
    }
}
