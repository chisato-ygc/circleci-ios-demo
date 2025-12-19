//
//  Task.swift
//  CircleCIDemoApp
//
//  Data model for tasks
//

import Foundation

/// A task model that conforms to Identifiable for use in SwiftUI lists
/// 
/// Key protocols:
/// - Identifiable: Provides a unique ID for list diffing
/// - Codable: Enables JSON encoding/decoding for persistence
/// - Equatable: Allows comparison between tasks
struct Task: Identifiable, Codable, Equatable {
    /// Unique identifier for the task
    let id: UUID
    
    /// Task title/description
    var title: String
    
    /// Whether the task is completed
    var isCompleted: Bool
    
    /// Priority level
    var priority: Priority
    
    /// Due date (optional)
    var dueDate: Date?
    
    /// Creation timestamp
    let createdAt: Date
    
    /// Priority levels for tasks
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var color: String {
            switch self {
            case .low: return "green"
            case .medium: return "orange"
            case .high: return "red"
            }
        }
    }
    
    /// Memberwise initializer with defaults
    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        priority: Priority = .medium,
        dueDate: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = createdAt
    }
}

// MARK: - Sample Data

extension Task {
    /// Sample tasks for previews and testing
    static let sampleTasks: [Task] = [
        Task(title: "Set up CircleCI pipeline", priority: .high),
        Task(title: "Configure M4 resource class", priority: .high),
        Task(title: "Write unit tests", priority: .medium),
        Task(title: "Add UI tests", priority: .medium),
        Task(title: "Configure code signing", priority: .low),
        Task(title: "Deploy to TestFlight", isCompleted: true, priority: .low)
    ]
}

// MARK: - Task Statistics

extension Array where Element == Task {
    /// Calculate completion percentage
    var completionPercentage: Double {
        guard !isEmpty else { return 0 }
        let completed = filter { $0.isCompleted }.count
        return Double(completed) / Double(count) * 100
    }
    
    /// Count of completed tasks
    var completedCount: Int {
        filter { $0.isCompleted }.count
    }
    
    /// Count of pending tasks
    var pendingCount: Int {
        filter { !$0.isCompleted }.count
    }
}

