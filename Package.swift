// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Claims",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Claims",
            targets: ["Claims"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "FolksamCommon",
                     url: "https://github.com/rashdan/FolksamCommon.git", .upToNextMajor(from: "0.1.4")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0"))
        
        //https://rashdan@bitbucket.org/folksamfuturelab/folksamcommon.git
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Claims",
            dependencies: [.product(name: "FolksamCommon", package: "FolksamCommon"), .product(name: "Alamofire", package: "Alamofire")]),
        .testTarget(
            name: "ClaimsTests",
            dependencies: ["Claims"]),
    ]
)
