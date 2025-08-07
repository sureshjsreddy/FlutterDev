import java.util.Properties
import java.io.FileInputStream

dependencies {
    implementation("androidx.core:core-ktx:1.13.1") // Or your current core-ktx version
    implementation("androidx.appcompat:appcompat:1.7.0") // Or your current appcompat version
    // ... other dependencies ...

    // Add this line for Play Core
    implementation("com.google.android.play:core:1.10.3") // Or the latest stable version

    // If you are using Kotlin specific Play Core features (usually not needed if just for Flutter's usage)
    // implementation("com.google.android.play:core-ktx:1.8.1")

    // ... flutterImplementation, etc.
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties") // Ensure this path is correct
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) { // .exists() here is fine (from java.io.File)
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.sureshdevs.retro_torch"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.sureshdevs.retro_torch"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists() &&
                keystoreProperties.containsKey("storeFile") &&
                keystoreProperties.containsKey("storePassword") &&
                keystoreProperties.containsKey("keyAlias") &&
                keystoreProperties.containsKey("keyPassword")) {

                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            } else {
                println("Warning: Release signing config not found or incomplete in key.properties. Build may fail.")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        getByName("debug") {
            isDebuggable = true
        }
    }
}

flutter {
    source = "../.."
}
