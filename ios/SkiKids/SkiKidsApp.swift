import SwiftUI
import SwiftData

@main
struct SkiKidsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Child.self)
    }
}
