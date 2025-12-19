# frozen_string_literal: true

# ============================================================================
# Gemfile - Ruby Dependencies for iOS Development
# ============================================================================
# This file defines Ruby gems used for iOS development automation.
# Run `bundle install` to install these dependencies.

source "https://rubygems.org"

# Fastlane - Automation for iOS builds and deployments
# https://fastlane.tools
gem "fastlane", "~> 2.219"

# CocoaPods - Dependency manager for iOS (if using)
# https://cocoapods.org
gem "cocoapods", "~> 1.14"

# xcpretty - Pretty-print xcodebuild output
# Makes build logs readable in CI
gem "xcpretty", "~> 0.3"

# ============================================================================
# Fastlane Plugins
# ============================================================================
# Add any Fastlane plugins here

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

