# 🍎 CircleCI iOS Demo Project

A sample iOS project demonstrating CircleCI integration with **Apple Silicon M4 resource_class** and **Xcode** builds.

## 🎯 Purpose

This project is designed to teach you:
- How CircleCI macOS executors work
- M4 resource_class configuration and benefits
- Xcode command-line builds with `xcodebuild`
- iOS testing strategies in CI/CD
- Secure secrets management

## 📁 Project Structure

```
circleci-ios-project/
├── .circleci/
│   └── config.yml              # CircleCI pipeline configuration
├── CircleCIDemoApp/
│   ├── CircleCIDemoAppApp.swift  # App entry point
│   ├── ContentView.swift         # Main view
│   ├── Models/
│   │   └── Task.swift            # Data model
│   ├── Views/
│   │   ├── TaskRowView.swift     # Task list row
│   │   ├── TaskStatsView.swift   # Statistics display
│   │   └── AddTaskView.swift     # Add task form
│   └── Config/
│       └── SecretsTemplate.swift # Template for secrets
├── CircleCIDemoAppTests/
│   └── TaskTests.swift           # Unit tests
├── CircleCIDemoAppUITests/
│   └── CircleCIDemoAppUITests.swift  # UI tests
├── fastlane/
│   └── Fastfile                  # Fastlane automation
├── .gitignore                    # Git ignore rules
├── Gemfile                       # Ruby dependencies
├── ExportOptions.plist           # Archive export config
├── IOS_CIRCLECI_LEARNING_GUIDE.md  # Comprehensive learning guide
├── SECRETS_GUIDE.md              # Secrets management guide
└── README.md                     # This file
```

## 🚀 Quick Start

### Prerequisites

- macOS with Xcode 16+ installed
- Ruby (for Fastlane/CocoaPods)
- CircleCI account

### Local Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd circleci-ios-project

# Install Ruby dependencies
bundle install

# Open in Xcode
open CircleCIDemoApp.xcodeproj

# Or build from command line
xcodebuild build \
  -project CircleCIDemoApp.xcodeproj \
  -scheme CircleCIDemoApp \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

### CircleCI Setup

1. Push this project to GitHub/GitLab/Bitbucket
2. Connect the repository to CircleCI
3. Add required environment variables (see [SECRETS_GUIDE.md](SECRETS_GUIDE.md))
4. Push a commit to trigger your first build!

## ⚙️ CircleCI Configuration Highlights

### M4 Resource Class

```yaml
executors:
  macos-m4-executor:
    macos:
      xcode: "16.1.0"
    resource_class: macos.m4.large  # Apple Silicon M4!
```

### Available M4 Options

| Resource Class | CPUs | RAM | Best For |
|----------------|------|-----|----------|
| `macos.m4.medium` | 4 | 8 GB | Small projects |
| `macos.m4.large` | 8 | 16 GB | Most projects ⭐ |
| `macos.m4.xlarge` | 12 | 24 GB | Large projects |

### Build Pipeline

```
checkout → restore cache → build → test → archive → deploy
```

## 📚 Learning Resources

- **[IOS_CIRCLECI_LEARNING_GUIDE.md](IOS_CIRCLECI_LEARNING_GUIDE.md)** - Deep dive into Xcode and M4
- **[SECRETS_GUIDE.md](SECRETS_GUIDE.md)** - How to manage secrets securely

## 🔐 Secrets Setup

**Never commit secrets to Git!** Instead:

1. Go to CircleCI Project Settings → Environment Variables
2. Add these variables:

| Variable | Description |
|----------|-------------|
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Key ID |
| `APP_STORE_CONNECT_ISSUER_ID` | Your issuer ID |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | Base64-encoded .p8 key |
| `MATCH_PASSWORD` | Fastlane Match encryption password |

See [SECRETS_GUIDE.md](SECRETS_GUIDE.md) for detailed instructions.

## 🧪 Running Tests

### Locally

```bash
# All tests
xcodebuild test \
  -project CircleCIDemoApp.xcodeproj \
  -scheme CircleCIDemoApp \
  -destination 'platform=iOS Simulator,name=iPhone 16'

# Using Fastlane
bundle exec fastlane test
```

### In CircleCI

Tests run automatically on every push. Results are:
- Displayed in the CircleCI dashboard
- Stored as artifacts (`.xcresult` bundles)
- Reported with timing for optimization

## 📱 The Demo App

A simple task management app built with SwiftUI featuring:
- Task list with completion tracking
- Priority levels (Low/Medium/High)
- Progress statistics
- Search functionality
- Add/Edit/Delete tasks

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - Feel free to use this as a learning resource!

---

**Happy Learning! 🎓**

For questions about CircleCI iOS builds, check the [official documentation](https://circleci.com/docs/ios-codesigning/).

