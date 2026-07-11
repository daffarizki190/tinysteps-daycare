allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = java.io.File("C:/Users/Public/Day_Care_Build")

subprojects {
    project.buildDir = java.io.File(rootProject.buildDir, project.name)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
