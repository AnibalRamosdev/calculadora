plugins {
    id("com.android.application")
    id("kotlin-android")
    // El plugin de Flutter debe aplicarse después de los de Android y Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.android_proyect"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // ID único de tu aplicación
        applicationId = "com.example.android_proyect"

        // --- CAMBIO CLAVE PARA IMAGE_PICKER ---
        minSdk = 21
        // --------------------------------------

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Configuración de firma para la versión de lanzamiento
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}