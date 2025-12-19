//
//  TaskRowView.swift
//  CircleCIDemoApp
//
//  A reusable row component for displaying tasks
//

import SwiftUI

/// A row view for displaying a single task in a list
/// 
/// Demonstrates:
/// - Component composition
/// - Closure-based actions
/// - Conditional styling
struct TaskRowView: View {
    /// The task to display
    let task: Task
    
    /// Action to perform when the task is tapped
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Completion checkbox
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            // Task details
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                HStack(spacing: 8) {
                    // Priority badge
                    PriorityBadge(priority: task.priority)
                    
                    // Due date if present
                    if let dueDate = task.dueDate {
                        Text(dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(task.title), \(task.priority.rawValue) priority, \(task.isCompleted ? "completed" : "pending")")
        .accessibilityHint("Double tap to toggle completion")
    }
}

/// A small badge showing task priority
struct PriorityBadge: View {
    let priority: Task.Priority
    
    var backgroundColor: Color {
        switch priority {
        case .low: return .green.opacity(0.2)
        case .medium: return .orange.opacity(0.2)
        case .high: return .red.opacity(0.2)
        }
    }
    
    var foregroundColor: Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var body: some View {
        Text(priority.rawValue)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
    }
}

// MARK: - Preview

#Preview {
    List {
        TaskRowView(task: Task(title: "Sample Task", priority: .high)) {
            print("Toggled")
        }
        TaskRowView(task: Task(title: "Completed Task", isCompleted: true, priority: .low)) {
            print("Toggled")
        }
    }
}

