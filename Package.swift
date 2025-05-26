// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "QuoteKit",
  platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)],
  products: [.library(name: "QuoteKit", targets: ["QuoteKit"])],
  dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.2.2"),
  ],
  targets: [
    .target(
      name: "QuoteKit", dependencies: [],
      plugins: [.plugin(name: "SwiftLint", package: "SwiftLintPlugin")]),
    .testTarget(name: "QuoteKitTests", dependencies: ["QuoteKit"]),
  ]
)
