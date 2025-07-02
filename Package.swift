// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TemplateApp",
    platforms: [
        .iOS(.v15),
    ],
    dependencies: [
        // Add your Swift Package dependencies here
        // Example:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
        // .package(url: "https://github.com/SwiftUIX/SwiftUIX", branch: "master"),
    ],
    targets: [
        .target(
            name: "TemplateApp",
            dependencies: [
                // Add your package dependencies here
                // Example:
                // "Alamofire",
                // "SwiftUIX",
            ]
        ),
    ]
)
