//
//  CircleCIDemoAppUITests.swift
//  CircleCIDemoAppUITests
//
//  UI tests for the CircleCI Demo App
//

import XCTest

/// UI Tests for the CircleCI Demo App
/// 
/// These tests run on an iOS Simulator using the M4 resource class.
/// UI tests are slower than unit tests but verify actual user interactions.
/// 
/// On CircleCI, these run in a separate job that can be parallelized.
final class CircleCIDemoAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Stop immediately when a failure occurs
        continueAfterFailure = false
        
        // Initialize the app
        app = XCUIApplication()
        
        // Set launch arguments for testing
        app.launchArguments = ["--uitesting"]
        
        // Set environment for testing (using safe test values, not real secrets)
        app.launchEnvironment = [
            "IS_UI_TESTING": "true",
            "API_BASE_URL": "https://test.example.com"
        ]
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Navigation Tests
    
    func testAppLaunches() throws {
        // Verify the main navigation title is visible
        let navTitle = app.navigationBars["CircleCI Demo"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5))
    }
    
    func testTaskListDisplays() throws {
        // Verify that the task list exists
        let taskList = app.collectionViews.firstMatch
        XCTAssertTrue(taskList.waitForExistence(timeout: 5))
    }
    
    // MARK: - Add Task Tests
    
    func testAddTaskButtonExists() throws {
        // Find the add button in the navigation bar
        let addButton = app.navigationBars.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Add' OR identifier CONTAINS 'plus'")
        ).firstMatch
        
        // If not found by label, try by image
        if !addButton.exists {
            let plusButton = app.buttons["plus.circle.fill"]
            XCTAssertTrue(plusButton.exists || addButton.exists, "Add button should exist")
        }
    }
    
    func testOpenAddTaskSheet() throws {
        // Tap the add button
        let addButton = app.navigationBars.buttons.element(boundBy: 1)
        
        if addButton.exists {
            addButton.tap()
            
            // Verify the sheet appears with "New Task" title
            let sheetTitle = app.navigationBars["New Task"]
            XCTAssertTrue(sheetTitle.waitForExistence(timeout: 3))
            
            // Verify cancel button exists
            let cancelButton = app.buttons["Cancel"]
            XCTAssertTrue(cancelButton.exists)
            
            // Dismiss the sheet
            cancelButton.tap()
        }
    }
    
    func testAddNewTask() throws {
        // Open add task sheet
        let addButton = app.navigationBars.buttons.element(boundBy: 1)
        guard addButton.exists else { return }
        
        addButton.tap()
        
        // Wait for sheet
        let sheetTitle = app.navigationBars["New Task"]
        guard sheetTitle.waitForExistence(timeout: 3) else {
            XCTFail("Add task sheet did not appear")
            return
        }
        
        // Enter task title
        let titleField = app.textFields["Task title"]
        if titleField.exists {
            titleField.tap()
            titleField.typeText("UI Test Task")
            
            // Tap Add button
            let addTaskButton = app.buttons["Add"]
            if addTaskButton.isEnabled {
                addTaskButton.tap()
                
                // Verify task was added (sheet should dismiss)
                XCTAssertFalse(sheetTitle.waitForExistence(timeout: 2))
            }
        }
    }
    
    // MARK: - Task Interaction Tests
    
    func testToggleTaskCompletion() throws {
        // Find a task cell
        let taskList = app.collectionViews.firstMatch
        guard taskList.waitForExistence(timeout: 5) else { return }
        
        // Get the first cell
        let firstCell = taskList.cells.firstMatch
        guard firstCell.exists else { return }
        
        // Find and tap the checkbox button within the cell
        let checkbox = firstCell.buttons.firstMatch
        if checkbox.exists {
            checkbox.tap()
            
            // The test passes if no crash occurs
            // Visual verification would require accessibility identifiers
        }
    }
    
    // MARK: - Search Tests
    
    func testSearchFunctionality() throws {
        // Find the search field (iOS 16+)
        let searchField = app.searchFields.firstMatch
        
        if searchField.waitForExistence(timeout: 3) {
            searchField.tap()
            searchField.typeText("CircleCI")
            
            // Verify search is active
            XCTAssertFalse(searchField.value as? String == "")
            
            // Clear search
            let clearButton = searchField.buttons["Clear text"]
            if clearButton.exists {
                clearButton.tap()
            }
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityLabels() throws {
        // Ensure main elements have accessibility labels
        let taskList = app.collectionViews.firstMatch
        guard taskList.waitForExistence(timeout: 5) else { return }
        
        // Check that cells have accessibility elements
        let cells = taskList.cells
        if cells.count > 0 {
            let firstCell = cells.firstMatch
            // Verify the cell is accessible
            XCTAssertTrue(firstCell.isHittable)
        }
    }
    
    // MARK: - Performance Tests
    
    func testLaunchPerformance() throws {
        // Measure app launch time
        // This is useful for tracking performance regressions in CI
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

// MARK: - Snapshot Tests (for visual regression)

extension CircleCIDemoAppUITests {
    
    /// Take a screenshot for visual comparison
    /// Screenshots are saved as test artifacts in CircleCI
    func testCaptureScreenshots() throws {
        // Main screen
        let mainScreenshot = app.screenshot()
        let mainAttachment = XCTAttachment(screenshot: mainScreenshot)
        mainAttachment.name = "Main Screen"
        mainAttachment.lifetime = .keepAlways
        add(mainAttachment)
        
        // Open add task sheet and capture
        let addButton = app.navigationBars.buttons.element(boundBy: 1)
        if addButton.exists {
            addButton.tap()
            
            // Wait for animation
            Thread.sleep(forTimeInterval: 0.5)
            
            let sheetScreenshot = app.screenshot()
            let sheetAttachment = XCTAttachment(screenshot: sheetScreenshot)
            sheetAttachment.name = "Add Task Sheet"
            sheetAttachment.lifetime = .keepAlways
            add(sheetAttachment)
        }
    }
}

