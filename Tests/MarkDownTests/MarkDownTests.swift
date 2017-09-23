//
//  MarkDown.swift
//  MarkDown
//
//  Created by Bernardo Breder on 29/01/17.
//
//

import XCTest
@testable import MarkDown

class MarkDownTests: XCTestCase {

	func test() throws {
        XCTAssertEqual("<p>a<a href=\"b\">c</a>d</p>", MarkDown(string: "a[b](c)d").html()[0])
        XCTAssertEqual("<p>abc</p>", MarkDown(string: "abc").html()[0])
        XCTAssertEqual("<h1>abc</h1>", MarkDown(string: "#abc").html()[0])
        XCTAssertEqual("<h2>abc</h2>", MarkDown(string: "##abc").html()[0])
        XCTAssertEqual("<h3>abc</h3>", MarkDown(string: "###abc").html()[0])
        XCTAssertEqual("<h4>abc</h4>", MarkDown(string: "####abc").html()[0])
        XCTAssertEqual("<h5>abc</h5>", MarkDown(string: "#####abc").html()[0])
        XCTAssertEqual("<h6>abc</h6>", MarkDown(string: "######abc").html()[0])
        XCTAssertEqual("<blockquote>abc</blockquote>", MarkDown(string: ">abc").html()[0])
        XCTAssertEqual("<uli>abc</uli>", MarkDown(string: "*abc").html()[0])
        XCTAssertEqual("<oli>abc</oli>", MarkDown(string: "1.abc").html()[0])
        XCTAssertEqual("<task value=\"false\">abc</task>", MarkDown(string: "* [ ]abc").html()[0])
        XCTAssertEqual("<task value=\"true\">abc</task>", MarkDown(string: "* [x]abc").html()[0])
        XCTAssertEqual("<pre>abc\ndef\nghi</pre>", MarkDown(string: "```\nabc\ndef\nghi").html()[0])
        XCTAssertEqual("<pre>abc\ndef\nghi</pre>", MarkDown(string: "```\nabc\ndef\nghi\n```").html()[0])
	}

}

