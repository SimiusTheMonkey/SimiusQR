plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing: the keystore password comes from the SIMIUSQR_KEYSTORE_PW environment
// variable (never a file in the repo). The keystore path defaults to
// ~/.simiusqr-signing/simiusqr-release.jks, override with SIMIUSQR_KEYSTORE. If either is
// missing -- e.g. someone cloned the repo to build it themselves -- the release build falls
// back to the debug key so `flutter build apk --release` still works.
val keystorePassword: String? = System.getenv("SIMIUSQR_KEYSTORE_PW")
val keystoreFile = file(
    System.getenv("SIMIUSQR_KEYSTORE")
        ?: "${System.getProperty("user.home")}/.simiusqr-signing/simiusqr-release.jks"
)
val hasReleaseKey = !keystorePassword.isNullOrEmpty() && keystoreFile.exists()

android {
    namespace = "com.simius.simiusqr"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.simius.simiusqr"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // mobile_scanner requires minSdk 23 (CameraX + ML Kit); Flutter's default template
        // value is lower, so it's bumped explicitly here.
        minSdk = maxOf(flutter.minSdkVersion, 23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                keyAlias = "simiusqr"
                keyPassword = keystorePassword
                storeFile = keystoreFile
                storePassword = keystorePassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
