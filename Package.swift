// swift-tools-version: 5.5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHelpers",
    platforms: [
       .macOS(.v10_15),
       .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftHelpers",
            targets: ["SwiftHelpers"]),
    ],
    dependencies: [
        .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "2.3.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", branch: "master"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", branch: "master"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftHelpers",
            dependencies: ["Alamofire", "Mocker", "SwiftyJSON"]),
        .testTarget(
            name: "SwiftHelpersTests",
            dependencies: ["SwiftHelpers", "Alamofire", "SwiftyJSON", "Mocker"],
            resources: [
                .copy("Resources/TestResponse.json"),
            ]
        ),
    ]
)
