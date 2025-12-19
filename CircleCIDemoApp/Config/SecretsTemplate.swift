//
//  SecretsTemplate.swift
//  CircleCIDemoApp
//
//  ⚠️ TEMPLATE FILE - Copy to Secrets.swift and fill in your values
//  🔐 Secrets.swift is gitignored and should NEVER be committed!
//
//  How to use:
//  1. Copy this file: cp SecretsTemplate.swift Secrets.swift
//  2. Fill in your actual values in Secrets.swift
//  3. Secrets.swift is already in .gitignore
//

import Foundation

/// Container for API keys and secrets
/// 
/// ⚠️ SECURITY BEST PRACTICES:
/// 
/// 1. NEVER hardcode secrets in source code
/// 2. Use environment variables in CI/CD
/// 3. Use Keychain for runtime storage on device
/// 4. Consider using a secrets management service (AWS Secrets Manager, etc.)
/// 
/// For CircleCI, set secrets as environment variables in:
/// - Project Settings > Environment Variables
/// - Or use Contexts for organization-wide secrets
enum Secrets {
    
    // MARK: - API Keys
    
    /// Your API base URL
    /// In CircleCI: Set as API_BASE_URL environment variable
    static let apiBaseURL: String = {
        // Try environment variable first (for CI builds)
        if let envValue = ProcessInfo.processInfo.environment["API_BASE_URL"] {
            return envValue
        }
        // Fallback for development - replace with your dev URL
        return "https://api.example.com"
    }()
    
    /// API Key for your backend
    /// In CircleCI: Set as API_KEY environment variable
    static let apiKey: String = {
        if let envValue = ProcessInfo.processInfo.environment["API_KEY"] {
            return envValue
        }
        // ⚠️ Replace with your development API key
        return "YOUR_DEV_API_KEY_HERE"
    }()
    
    // MARK: - Third-Party Services
    
    /// Analytics service key
    static let analyticsKey: String = {
        ProcessInfo.processInfo.environment["ANALYTICS_KEY"] ?? "dev-analytics-key"
    }()
    
    /// Crash reporting service key
    static let crashReportingKey: String = {
        ProcessInfo.processInfo.environment["CRASH_REPORTING_KEY"] ?? "dev-crash-key"
    }()
    
    // MARK: - Feature Flags
    
    /// Whether we're running in CI environment
    static var isCI: Bool {
        ProcessInfo.processInfo.environment["CI"] == "true" ||
        ProcessInfo.processInfo.environment["CIRCLECI"] == "true"
    }
    
    /// Current build configuration
    static var buildConfiguration: BuildConfiguration {
        #if DEBUG
        return .debug
        #else
        if isCI {
            return .ci
        }
        return .release
        #endif
    }
    
    enum BuildConfiguration {
        case debug
        case ci
        case release
    }
}

// MARK: - Keychain Helper

/// Helper for secure storage of secrets at runtime
/// Use this for storing tokens received from authentication
enum KeychainHelper {
    
    private static let service = "com.example.CircleCIDemoApp"
    
    /// Save a secret to Keychain
    static func save(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item first
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }
    
    /// Retrieve a secret from Keychain
    static func get(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil
            }
            throw KeychainError.retrieveFailed(status)
        }
        
        guard let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.decodingFailed
        }
        
        return string
    }
    
    /// Delete a secret from Keychain
    static func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
    
    enum KeychainError: Error {
        case encodingFailed
        case decodingFailed
        case saveFailed(OSStatus)
        case retrieveFailed(OSStatus)
        case deleteFailed(OSStatus)
    }
}

