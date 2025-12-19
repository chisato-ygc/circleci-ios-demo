# 🔐 Secrets Management Guide for CircleCI iOS

This guide explains how to securely manage secrets for your iOS app in CircleCI.

## ⚠️ Golden Rules

1. **NEVER commit secrets to Git** - No API keys, certificates, or passwords in code
2. **Use environment variables** - Store secrets in CircleCI's secure storage
3. **Rotate secrets regularly** - Change keys periodically, especially after team changes
4. **Audit access** - Review who has access to secrets

---

## 📍 Where to Store Secrets in CircleCI

### Option 1: Project Environment Variables (Most Common)

1. Go to **CircleCI Dashboard**
2. Select your project
3. Click **Project Settings** (gear icon)
4. Navigate to **Environment Variables**
5. Click **Add Environment Variable**

```
┌─────────────────────────────────────────────────────────────┐
│  Project Settings > Environment Variables                    │
├─────────────────────────────────────────────────────────────┤
│  Name                              Value                     │
│  ──────────────────────────────    ─────────────────────    │
│  APP_STORE_CONNECT_API_KEY_ID      ABC123DEF4               │
│  APP_STORE_CONNECT_ISSUER_ID       12345678-1234-...        │
│  APP_STORE_CONNECT_API_KEY_CONTENT (base64 encoded .p8)     │
│  MATCH_PASSWORD                    ••••••••••               │
│  MATCH_GIT_URL                     git@github.com:...       │
└─────────────────────────────────────────────────────────────┘
```

### Option 2: Contexts (Organization-Wide Secrets)

Use contexts to share secrets across multiple projects:

1. Go to **Organization Settings**
2. Click **Contexts**
3. Create a context (e.g., `ios-signing`)
4. Add environment variables to the context
5. Reference in your config:

```yaml
workflows:
  build-deploy:
    jobs:
      - deploy:
          context:
            - ios-signing  # Uses secrets from this context
```

---

## 🍎 App Store Connect API Key Setup

### Step 1: Generate API Key in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **Users and Access**
3. Select **Keys** tab
4. Click the **+** button to generate a new key
5. Give it a name like "CircleCI"
6. Set role to **App Manager** or **Developer**
7. Download the `.p8` file (you can only download it once!)
8. Note the **Key ID** and **Issuer ID**

### Step 2: Encode the Key for CircleCI

```bash
# Convert the .p8 file to base64 for storage
cat AuthKey_XXXXXXXXXX.p8 | base64 | tr -d '\n'
```

### Step 3: Add to CircleCI

Add these environment variables:

| Variable | Value |
|----------|-------|
| `APP_STORE_CONNECT_API_KEY_ID` | The Key ID (e.g., `ABC123DEF4`) |
| `APP_STORE_CONNECT_ISSUER_ID` | The Issuer ID (UUID format) |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | Base64-encoded .p8 content |

---

## 🔏 Code Signing Certificates

### Method 1: Using Fastlane Match (Recommended)

Match stores certificates in a Git repo (encrypted) or cloud storage.

1. Create a private Git repo for certificates
2. Run `fastlane match init` locally
3. Add to CircleCI:

| Variable | Value |
|----------|-------|
| `MATCH_PASSWORD` | Encryption password |
| `MATCH_GIT_URL` | Private repo URL |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64 of `username:token` |

### Method 2: Manual Certificate Import

For manual setup, base64-encode your .p12 file:

```bash
# Encode your distribution certificate
cat distribution.p12 | base64 > cert_base64.txt
```

Then in your CircleCI config:

```yaml
- run:
    name: Import Certificates
    command: |
      # Decode certificate
      echo $DISTRIBUTION_CERTIFICATE | base64 --decode > /tmp/distribution.p12
      
      # Create keychain
      security create-keychain -p "" build.keychain
      security default-keychain -s build.keychain
      security unlock-keychain -p "" build.keychain
      
      # Import certificate
      security import /tmp/distribution.p12 \
        -k build.keychain \
        -P "$CERTIFICATE_PASSWORD" \
        -T /usr/bin/codesign \
        -T /usr/bin/security
      
      # Allow codesign to access
      security set-key-partition-list \
        -S apple-tool:,apple: \
        -s -k "" build.keychain
```

---

## 🛡️ Security Best Practices

### 1. Use Restricted Contexts

```yaml
workflows:
  deploy:
    jobs:
      - deploy-production:
          context: production-secrets
          filters:
            branches:
              only: main  # Only main branch can use production secrets
```

### 2. Mask Secrets in Logs

CircleCI automatically masks environment variables, but be careful with:

```yaml
# ❌ BAD - might expose secrets
- run: echo "Key is $API_KEY"

# ✅ GOOD - verify without exposing
- run: |
    if [ -n "$API_KEY" ]; then
      echo "API_KEY is set (${#API_KEY} characters)"
    else
      echo "ERROR: API_KEY is not set"
    fi
```

### 3. Limit Secret Scope

```yaml
jobs:
  build:
    # No secrets needed for build
    steps:
      - build-app
  
  deploy:
    # Only this job needs secrets
    environment:
      # Reference only what's needed
      FASTLANE_USER: ${APPLE_ID}
```

### 4. Audit Trail

CircleCI provides audit logs for:
- Who added/modified environment variables
- Which jobs accessed which contexts
- SSH access to builds

---

## 📱 Secrets in Your App Code

### Reading Secrets at Build Time

For values needed in the app (like API URLs):

```swift
// In your Swift code
enum Config {
    static let apiURL: String = {
        // CI environment variable
        if let url = ProcessInfo.processInfo.environment["API_URL"] {
            return url
        }
        // Fallback for local development
        #if DEBUG
        return "https://dev-api.example.com"
        #else
        return "https://api.example.com"
        #endif
    }()
}
```

### Using .xcconfig Files

Create environment-specific config files:

```
// Debug.xcconfig
API_URL = https:/$()/dev-api.example.com
ANALYTICS_KEY = dev-key

// Release.xcconfig  
API_URL = https:/$()/api.example.com
ANALYTICS_KEY = $(ANALYTICS_KEY)  // From environment
```

Then in CircleCI:

```yaml
- run:
    name: Configure for Release
    command: |
      # Inject secrets into xcconfig
      echo "ANALYTICS_KEY = $ANALYTICS_KEY" >> Release.xcconfig
```

---

## 🧹 Secret Rotation Checklist

When rotating secrets:

- [ ] Generate new credentials
- [ ] Update CircleCI environment variables
- [ ] Verify builds still work
- [ ] Revoke old credentials
- [ ] Update documentation
- [ ] Notify team members

---

## ❓ Troubleshooting

### "Could not find App Store Connect API key"

```bash
# Verify key is set
echo "Key ID length: ${#APP_STORE_CONNECT_API_KEY_ID}"
echo "Issuer ID length: ${#APP_STORE_CONNECT_ISSUER_ID}"
echo "Key content length: ${#APP_STORE_CONNECT_API_KEY_CONTENT}"
```

### "Code signing failed"

1. Verify certificates are not expired
2. Check provisioning profiles match bundle ID
3. Ensure MATCH_PASSWORD is correct
4. Try `fastlane match nuke` and re-create (destructive!)

### "Permission denied"

- Verify your API key has the correct role
- Check context restrictions in workflow config
- Ensure branch is allowed to access the context

