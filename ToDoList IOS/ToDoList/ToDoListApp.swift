import SwiftUI
import SwiftData

@main
struct ToDoListApp: App {
    @StateObject private var themeManager = ThemeManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        requestNotificationPermissions()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
        }
        .modelContainer(sharedModelContainer)
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error)")
            }
        }
    }
}

