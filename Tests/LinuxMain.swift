//
//  MarkDownTests.swift
//  MarkDown
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import MarkDownTests

extension MarkDownTests {

	static var allTests : [(String, (MarkDownTests) -> () throws -> Void)] {
		return [
			("test", test),
		]
	}

}

XCTMain([
	testCase(MarkDownTests.allTests),
])

