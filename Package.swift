// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

// Don't rely on those environment variables. They are ONLY testing conveniences:
// $ SQLITE_ENABLE_FTS5=1 SQLITE_ENABLE_PREUPDATE_HOOK=1 make test_SPM
var swiftSettings: [SwiftSetting] = []
var cSettings: [CSetting] = []
if ProcessInfo.processInfo.environment["SQLITE_ENABLE_FTS5"] == "1" {
    swiftSettings.append(.define("SQLITE_ENABLE_FTS5"))
}
if ProcessInfo.processInfo.environment["SQLITE_ENABLE_PREUPDATE_HOOK"] == "1" {
    swiftSettings.append(.define("SQLITE_ENABLE_PREUPDATE_HOOK"))
    cSettings.append(.define("GRDB_SQLITE_ENABLE_PREUPDATE_HOOK"))
}

let package = Package(
    name: "GRDB",
    defaultLocalization: "en", // for tests
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(name: "GRDB", targets: ["GRDB"]),
        .library(name: "GRDB-dynamic", type: .dynamic, targets: ["GRDB"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GRDB",
            dependencies: ["SQLCipher"],
            path: "GRDB",
            cSettings: [
                .define("SQLITE_HAS_CODEC"),
                .define("SQLITE_TEMP_STORE", to: "2"),
                .define("SQLITE_SOUNDEX"),
                .define("SQLITE_THREADSAFE"),
                .define("SQLITE_ENABLE_RTREE"),
                .define("SQLITE_ENABLE_STAT3"),
                .define("SQLITE_ENABLE_STAT4"),
                .define("SQLITE_ENABLE_COLUMN_METADATA"),
                .define("SQLITE_ENABLE_MEMORY_MANAGEMENT"),
                .define("SQLITE_ENABLE_LOAD_EXTENSION"),
                .define("SQLITE_ENABLE_FTS4"),
                .define("SQLITE_ENABLE_FTS4_UNICODE61"),
                .define("SQLITE_ENABLE_FTS3_PARENTHESIS"),
                .define("SQLITE_ENABLE_UNLOCK_NOTIFY"),
                .define("SQLITE_ENABLE_JSON1"),
                .define("SQLITE_ENABLE_FTS5"),
                .define("SQLCIPHER_CRYPTO_CC"),
                .define("HAVE_USLEEP", to: "1"),
                .define("SQLITE_MAX_VARIABLE_NUMBER", to: "99999")
            ],
            swiftSettings: [
                .define("SQLITE_HAS_CODEC"),
                .define("GRDBCIPHER"),
                .define("SQLITE_ENABLE_FTS5")
            ]),
        .target(
            name: "SQLCipher",
            cSettings: [
                .define("NDEBUG"),
                .define("SQLITE_HAS_CODEC"),
                .define("SQLITE_TEMP_STORE", to: "2"),
                .define("SQLITE_SOUNDEX"),
                .define("SQLITE_THREADSAFE"),
                .define("SQLITE_ENABLE_RTREE"),
                .define("SQLITE_ENABLE_STAT3"),
                .define("SQLITE_ENABLE_STAT4"),
                .define("SQLITE_ENABLE_COLUMN_METADATA"),
                .define("SQLITE_ENABLE_MEMORY_MANAGEMENT"),
                .define("SQLITE_ENABLE_LOAD_EXTENSION"),
                .define("SQLITE_ENABLE_FTS4"),
                .define("SQLITE_ENABLE_FTS4_UNICODE61"),
                .define("SQLITE_ENABLE_FTS3_PARENTHESIS"),
                .define("SQLITE_ENABLE_UNLOCK_NOTIFY"),
                .define("SQLITE_ENABLE_JSON1"),
                .define("SQLITE_ENABLE_FTS5"),
                .define("SQLCIPHER_CRYPTO_CC"),
                .define("HAVE_USLEEP", to: "1"),
                .define("SQLITE_MAX_VARIABLE_NUMBER", to: "99999"),
                .define("HAVE_GETHOSTUUID", to: "0"),
                .unsafeFlags(["-w"])
            ]),    
        .testTarget(
            name: "GRDBTests",
            dependencies: ["GRDB"],
            path: "Tests",
            exclude: [
                "CocoaPods",
                "Crash",
                "CustomSQLite",
                "GRDBTests/getThreadsCount.c",
                "Info.plist",
                "Performance",
                "SPM",
                "generatePerformanceReport.rb",
                "parsePerformanceTests.rb",
            ],
            resources: [
                .copy("GRDBTests/Betty.jpeg"),
                .copy("GRDBTests/InflectionsTests.json"),
            ],
            cSettings: cSettings,
            swiftSettings: swiftSettings)
    ],
    swiftLanguageVersions: [.v5]
)
