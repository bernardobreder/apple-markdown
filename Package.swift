//
//  Package.swift
//  MarkDown
//
//

import PackageDescription

let package = Package(
	name: "MarkDown",
	targets: [
		Target(name: "MarkDown", dependencies: ["Regex"]),
		Target(name: "Regex", dependencies: []),
	]
)

