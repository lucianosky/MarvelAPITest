//
//  ThumbnailModelTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 06/07/2018.
//

import XCTest

@testable import MarvelAPIApp

class ThumbnailModelTests: XCTestCase {
    
    func testInit() {
        let path = "path"
        let ext = "ext"
        let thumbnail = ThumbnailModel(path: path, ext: ext)
        XCTAssertEqual(thumbnail.path, path)
        XCTAssertEqual(thumbnail.ext, ext)
        let thumbnailCopy = ThumbnailModel(path: path, ext: ext)
        XCTAssert(thumbnail == thumbnailCopy)
    }
    
}
