import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var showingAddTask = false
    @State private var selectedPriority: Int? = nil
    @State private var filterTag: String = ""
    @StateObject private var themeManager = ThemeManager()

    var body: some View {
        NavigationSplitView {
            VStack {
                Picker("Filter by Priority", selection: $selectedPriority) {
                    Text("All").tag(nil as Int?)
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Picker("Filter by Due Date", selection: $filterTag) {
                    Text("No Filter").tag("")
                    Text("Upcoming").tag("Upcoming")
                    Text("Past Due").tag("Past Due")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(filteredItems) { item in
                        NavigationLink {
                            ItemDetailView(item: item)
                        } label: {
                            HStack {
                                Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                Spacer()
                                if item.isCompleted {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddTask.toggle() }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            Button("Light Mode") { themeManager.currentTheme = .light }
                            Button("Dark Mode") { themeManager.currentTheme = .dark }
                        } label: {
                            Text("Theme")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        } detail: {
            Text("Select an item")
        }
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
    }

    private var filteredItems: [Item] {
        items.filter { item in
            (selectedPriority == nil || item.priority == selectedPriority) &&
            (filterTag == "Upcoming" && (item.dueDate ?? Date()) >= Date()) ||
            (filterTag == "Past Due" && (item.dueDate ?? Date()) < Date()) ||
            (filterTag.isEmpty)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

