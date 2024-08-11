import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode // For dismissing the view
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var priority: Int = 1
    @State private var tags: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Picker("Priority", selection: $priority) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                TextField("Tags (comma separated)", text: $tags)
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addItem()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func addItem() {
        let newItem = Item(
            timestamp: Date(),
            dueDate: dueDate,
            isCompleted: false,
            priority: priority,
            tags: tags.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        )
        modelContext.insert(newItem)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving new item: \(error)")
        }
    }
}

