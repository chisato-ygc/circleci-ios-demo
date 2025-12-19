//
//  AddTaskView.swift
//  CircleCIDemoApp
//
//  Form for adding new tasks
//

import SwiftUI

/// A sheet view for adding new tasks
/// 
/// Demonstrates:
/// - Form input handling
/// - Sheet dismissal
/// - Closure callbacks
/// - Input validation
struct AddTaskView: View {
    /// Environment value for dismissing the sheet
    @Environment(\.dismiss) private var dismiss
    
    /// Form state
    @State private var title = ""
    @State private var priority: Task.Priority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    
    /// Callback when task is created
    let onAdd: (Task) -> Void
    
    /// Validation: title must not be empty
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Task details section
                Section {
                    TextField("Task title", text: $title)
                        .textContentType(.none)
                        .autocorrectionDisabled(false)
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(Task.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                } header: {
                    Text("Task Details")
                }
                
                // Due date section
                Section {
                    Toggle("Set due date", isOn: $hasDueDate.animation())
                    
                    if hasDueDate {
                        DatePicker(
                            "Due date",
                            selection: $dueDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                } header: {
                    Text("Due Date")
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addTask()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    /// Create and add the new task
    private func addTask() {
        let task = Task(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            priority: priority,
            dueDate: hasDueDate ? dueDate : nil
        )
        onAdd(task)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddTaskView { task in
        print("Added: \(task.title)")
    }
}

