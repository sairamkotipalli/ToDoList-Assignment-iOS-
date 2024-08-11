import Foundation
import SwiftData

@Model
final class Item: ObservableObject, Identifiable {
    var id: UUID
    var timestamp: Date
    var dueDate: Date?
    var isCompleted: Bool
    var priority: Int // 1 for low, 2 for medium, 3 for high
    var tags: [String]

    init(timestamp: Date, dueDate: Date? = nil, isCompleted: Bool = false, priority: Int = 1, tags: [String] = []) {
        self.id = UUID()
        self.timestamp = timestamp
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.priority = priority
        self.tags = tags
    }
}

