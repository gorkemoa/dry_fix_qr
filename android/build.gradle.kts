buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val isLegacyPlugin = project.name == "receive_sharing_intent"
    val versionString = if (isLegacyPlugin) "1.8" else "17"
    val jvmTargetVersion = if (isLegacyPlugin) org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8 else org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17

    project.tasks.withType(JavaCompile::class.java).configureEach {
        sourceCompatibility = versionString
        targetCompatibility = versionString
    }
    project.tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile::class.java).configureEach {
        compilerOptions {
            jvmTarget.set(jvmTargetVersion)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
