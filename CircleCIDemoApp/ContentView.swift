//
//  ContentView.swift
//  CircleCIDemoApp
//
//  Main content view demonstrating SwiftUI components
//

import SwiftUI

/// The main content view of our application
/// 
/// This view demonstrates several SwiftUI concepts:
/// - Navigation with NavigationStack
/// - State management with @State and @EnvironmentObject
/// - List views with custom rows
/// - Sheet presentations
struct ContentView: View {
    
    /// Access to app-wide state
    @EnvironmentObject var appState: AppState
    
    /// Local view state
    @State private var tasks: [Task] = Task.sampleTasks
    @State private var showingAddTask = false
    @State private var searchText = ""
    
    /// Computed property for filtered tasks
    var filteredTasks: [Task] {
        if searchText.isEmpty {
            return tasks
        }
        return tasks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with stats
                TaskStatsView(tasks: tasks)
                    .padding()
                    .background(Color(.systemBackground))
                
                // Task list
                List {
                    ForEach(filteredTasks) { task in
                        TaskRowView(task: task) {
                            toggleTask(task)
                        }
                    }
                    .onDelete(perform: deleteTasks)
                    .onMove(perform: moveTasks)
                }
                .listStyle(.insetGrouped)
                .searchable(text: $searchText, prompt: "Search tasks")
            }
            .navigationTitle("CircleCI Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView { newTask in
                    tasks.append(newTask)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    /// Toggle task completion status
    private func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    /// Delete tasks at specified offsets
    private func deleteTasks(at offsets: IndexSet) {
        // Map filtered indices back to original array
        let tasksToDelete = offsets.map { filteredTasks[$0] }
        tasks.removeAll { task in
            tasksToDelete.contains { $0.id == task.id }
        }
    }
    
    /// Move tasks for reordering
    private func moveTasks(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(AppState())
}

