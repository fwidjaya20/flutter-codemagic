[![Codemagic build status](https://api.codemagic.io/apps/5f59a56a4a656e1f9d79905f/5f59a56a4a656e1f9d79905e/status_badge.svg)](https://codemagic.io/apps/5f59a56a4a656e1f9d79905f/5f59a56a4a656e1f9d79905e/latest_build)

# Flutter CI CD (Code Magic)

## GUI Config
1. Open [Code Magic](https://codemagic.io)
2. Open `App` Menu
3. Choose Your Application
4. Click `Set up Build` or `Cog Icon`
5. There is 6 Steps, need to be set

### 1st Build Triggers
In this section, you need to tell the machine which branch to watch (eg. *master*).
After choosing the branch, we need to choose the pipeline for triggering action (eg. *trigger on push*).

### 2nd Environment Variables
You can add your own Environment Variables here

### 3rd Dependency Caching
You can set, which dependency need to be cache for faster building.

### 4th Test
Select wich tests to run (eg. Enable Flutter Test and Stop build if test fail).
Select the device for testing (eg. Android)

### 5th Build
Select the Flutter Version.
Select the Xcode Version for iOS.
Select the CocoaPods Version for iOS dependency.
Select the build Platforms.
Select the build arguments for each Platform to be build.

### 6th Publish
Select the Publish Target to be sent if the process succeed

## Yaml Config
example
```yaml
# Automatically generated on 2020-09-10 UTC from https://codemagic.io/app/5f59a56a4a656e1f9d79905f/settings
# Note that this configuration is not an exact match to UI settings. Review and adjust as necessary.

workflows:
  default-workflow:
    name: Default Workflow
    max_build_duration: 60
    environment:
      flutter: stable
      xcode: latest
      cocoapods: default
    triggering:
      events:
        - push
      branch_patterns:
        - pattern: '*master*'
          include: true
          source: true
    scripts:
      - |
        # set up debug keystore
        rm -f ~/.android/debug.keystore
        keytool -genkeypair \
          -alias androiddebugkey \
          -keypass android \
          -keystore ~/.android/debug.keystore \
          -storepass android \
          -dname 'CN=Android Debug,O=Android,C=US' \
          -keyalg 'RSA' \
          -keysize 2048 \
          -validity 10000
      - |
        # set up local properties
        echo "flutter.sdk=$HOME/programs/flutter" > "$FCI_BUILD_DIR/android/local.properties"
      - cd . && flutter packages pub get
      - cd . && flutter analyze
      - cd . && flutter test
      - cd . && flutter build apk --release
    artifacts:
      - build/**/outputs/**/*.apk
      - build/**/outputs/**/*.aab
      - build/**/outputs/**/mapping.txt
      - flutter_drive.log
    publishing:
      email:
        recipients:
          - f.widjaya20@gmail.com
```
