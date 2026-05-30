plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    namespace = "org.theqaf.app"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {

        applicationId = "org.theqaf.app"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {

        create("release") {

            storeFile = file("../upload-keystore.jks")
            storePassword = "android"

            keyAlias = "upload"
            keyPassword = "android"
        }
    }

    buildTypes {

        release {

            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }

        debug {

            signingConfig = signingConfigs.getByName("debug")
        }
    }


}

dependencies {

    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.0.4"
    )
}

flutter {
    source = "../.."
}