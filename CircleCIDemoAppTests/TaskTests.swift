//
//  TaskTests.swift
//  CircleCIDemoAppTests
//
//  Unit tests for the Task model
//

import XCTest
@testable import CircleCIDemoApp

/// Unit tests for the Task model
/// 
/// These tests run on CircleCI using the M4 resource class.
/// Unit tests are fast and don't require a simulator.
final class TaskTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testTaskInitialization() {
        // Given
        let title = "Test Task"
        
        // When
        let task = Task(title: title)
        
        // Then
        XCTAssertEqual(task.title, title)
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.priority, .medium)
        XCTAssertNil(task.dueDate)
        XCTAssertNotNil(task.id)
        XCTAssertNotNil(task.createdAt)
    }
    
    func testTaskInitializationWithAllParameters() {
        // Given
        let id = UUID()
        let title = "Complete Task"
        let dueDate = Date()
        let createdAt = Date()
        
        // When
        let task = Task(
            id: id,
            title: title,
            isCompleted: true,
            priority: .high,
            dueDate: dueDate,
            createdAt: createdAt
        )
        
        // Then
        XCTAssertEqual(task.id, id)
        XCTAssertEqual(task.title, title)
        XCTAssertTrue(task.isCompleted)
        XCTAssertEqual(task.priority, .high)
        XCTAssertEqual(task.dueDate, dueDate)
        XCTAssertEqual(task.createdAt, createdAt)
    }
    
    // MARK: - Priority Tests
    
    func testPriorityColors() {
        XCTAssertEqual(Task.Priority.low.color, "green")
        XCTAssertEqual(Task.Priority.medium.color, "orange")
        XCTAssertEqual(Task.Priority.high.color, "red")
    }
    
    func testPriorityRawValues() {
        XCTAssertEqual(Task.Priority.low.rawValue, "Low")
        XCTAssertEqual(Task.Priority.medium.rawValue, "Medium")
        XCTAssertEqual(Task.Priority.high.rawValue, "High")
    }
    
    func testAllPriorityCases() {
        let allCases = Task.Priority.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.low))
        XCTAssertTrue(allCases.contains(.medium))
        XCTAssertTrue(allCases.contains(.high))
    }
    
    // MARK: - Codable Tests
    
    func testTaskEncodingDecoding() throws {
        // Given
        let originalTask = Task(
            title: "Codable Test",
            isCompleted: true,
            priority: .high,
            dueDate: Date()
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalTask)
        
        let decoder = JSONDecoder()
        let decodedTask = try decoder.decode(Task.self, from: data)
        
        // Then
        XCTAssertEqual(decodedTask.id, originalTask.id)
        XCTAssertEqual(decodedTask.title, originalTask.title)
        XCTAssertEqual(decodedTask.isCompleted, originalTask.isCompleted)
        XCTAssertEqual(decodedTask.priority, originalTask.priority)
    }
    
    // MARK: - Equatable Tests
    
    func testTaskEquality() {
        // Given
        let id = UUID()
        let task1 = Task(id: id, title: "Same Task")
        let task2 = Task(id: id, title: "Same Task")
        
        // Then
        XCTAssertEqual(task1, task2)
    }
    
    func testTaskInequality() {
        // Given
        let task1 = Task(title: "Task 1")
        let task2 = Task(title: "Task 2")
        
        // Then
        XCTAssertNotEqual(task1, task2)
    }
    
    // MARK: - Sample Data Tests
    
    func testSampleTasksExist() {
        let samples = Task.sampleTasks
        XCTAssertFalse(samples.isEmpty)
        XCTAssertGreaterThanOrEqual(samples.count, 3)
    }
}

// MARK: - Array Extension Tests

final class TaskArrayExtensionTests: XCTestCase {
    
    func testCompletionPercentageEmpty() {
        let tasks: [Task] = []
        XCTAssertEqual(tasks.completionPercentage, 0)
    }
    
    func testCompletionPercentageNoneCompleted() {
        let tasks = [
            Task(title: "Task 1"),
            Task(title: "Task 2")
        ]
        XCTAssertEqual(tasks.completionPercentage, 0)
    }
    
    func testCompletionPercentageAllCompleted() {
        let tasks = [
            Task(title: "Task 1", isCompleted: true),
            Task(title: "Task 2", isCompleted: true)
        ]
        XCTAssertEqual(tasks.completionPercentage, 100)
    }
    
    func testCompletionPercentagePartial() {
        let tasks = [
            Task(title: "Task 1", isCompleted: true),
            Task(title: "Task 2", isCompleted: false),
            Task(title: "Task 3", isCompleted: false),
            Task(title: "Task 4", isCompleted: true)
        ]
        XCTAssertEqual(tasks.completionPercentage, 50)
    }
    
    func testCompletedCount() {
        let tasks = [
            Task(title: "Task 1", isCompleted: true),
            Task(title: "Task 2", isCompleted: false),
            Task(title: "Task 3", isCompleted: true)
        ]
        XCTAssertEqual(tasks.completedCount, 2)
    }
    
    func testPendingCount() {
        let tasks = [
            Task(title: "Task 1", isCompleted: true),
            Task(title: "Task 2", isCompleted: false),
            Task(title: "Task 3", isCompleted: false)
        ]
        XCTAssertEqual(tasks.pendingCount, 2)
    }
}

