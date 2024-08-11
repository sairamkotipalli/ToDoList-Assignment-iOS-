import SwiftUI
import UserNotifications

struct ItemDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var item: Item

    var body: some View {
        Form {
            DatePicker("Due Date", selection: Binding(
                get: { item.dueDate ?? Date() },
                set: { item.dueDate = $0 }
            ), displayedComponents: .date)

            Toggle("Completed", isOn: $item.isCompleted)

            TextField("Tags", text: Binding(
                get: { item.tags.joined(separator: ", ") },
                set: { item.tags = $0.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) } }
            ))

            Picker("Priority", selection: $item.priority) {
                Text("Low").tag(1)
                Text("Medium").tag(2)
                Text("High").tag(3)
            }
            
            Button("Set Reminder") {
                scheduleNotification()
            }
        }
        .navigationTitle("Edit Item")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Save") {
                    saveItem()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete") {
                    deleteItem()
                }
            }
        }
    }

    private func scheduleNotification() {
        guard let dueDate = item.dueDate else { return }

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget to complete: \(item.timestamp)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: dueDate.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    private func saveItem() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving item: \(error)")
        }
    }

    private func deleteItem() {
        modelContext.delete(item)
        do {
            try modelContext.save()
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}

