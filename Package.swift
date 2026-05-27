// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SettingsUI",
    platforms: [.macOS(.v14)],
    products: [.library(name: "SettingsUI", targets: ["SettingsUI"])],
    dependencies: [
        .package(url: "https://github.com/akhlaqahmad/docked-appcore.git", branch: "main"),
        .package(url: "https://github.com/akhlaqahmad/docked-designsystem.git", branch: "main"),
        .package(url: "https://github.com/akhlaqahmad/docked-displaykit.git", branch: "main"),
        .package(url: "https://github.com/akhlaqahmad/docked-workspacekit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "SettingsUI",
            dependencies: ["AppCore", "DesignSystem", "DisplayKit", "WorkspaceKit"]
        )
    ]
)
