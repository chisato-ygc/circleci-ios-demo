//
//  CircleCIDemoAppApp.swift
//  CircleCIDemoApp
//
//  A sample iOS app demonstrating CircleCI integration with M4 resource_class
//

import SwiftUI

/// The main entry point for our SwiftUI application
/// 
/// In SwiftUI, the `@main` attribute marks this as the app's entry point.
/// The `App` protocol requires a `body` property that returns a `Scene`.
@main
struct CircleCIDemoAppApp: App {
    
    /// StateObject for app-wide state management
    /// This persists across view updates and is created only once
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

/// App-wide state management using ObservableObject
/// 
/// This pattern allows state to be shared across multiple views.
/// Changes to @Published properties automatically trigger view updates.
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    @Published var theme: AppTheme = .system
    
    enum AppTheme: String, CaseIterable {
        case light, dark, system
    }
}

