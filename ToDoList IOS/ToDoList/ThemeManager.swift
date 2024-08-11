import SwiftUI

enum Theme: String {
    case light
    case dark
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "appTheme")
        }
    }

    init() {
        let themeString = UserDefaults.standard.string(forKey: "appTheme") ?? Theme.light.rawValue
        currentTheme = Theme(rawValue: themeString) ?? .light
    }
}

