plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // <- Línea necesaria
}

android {
    namespace = "com.example.turismoynotificaciones"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = flutter.ndkVersion

    defaultConfig {
     applicationId = "com.example.turismoynotificaciones"
     minSdk = flutter.minSdkVersion.toInt()
     targetSdk = flutter.targetSdkVersion.toInt()
     versionCode = flutter.versionCode.toInt()
     versionName = flutter.versionName
    }

    compileOptions {
        // sourceCompatibility(JavaVersion.VERSION_11)
        // targetCompatibility(JavaVersion.VERSION_11)
        sourceCompatibility = JavaVersion.VERSION_17 
        targetCompatibility = JavaVersion.VERSION_17 
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
implementation("com.google.firebase:firebase-analytics")
implementation("com.google.firebase:firebase-messaging")
}
