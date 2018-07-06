//
//  ComicModelTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 29/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class ComicModelTests: XCTestCase {
    
    func testInit() {
        let id = 1000
        let title = "Avengers: The Initiative"
        let thumbnail = ThumbnailModel(path: "path", ext: "ext")

        let avengers = ComicModel(id: id, title: title, thumbnail: thumbnail)
        XCTAssertEqual(avengers.id, id)
        XCTAssertEqual(avengers.title, title)
        XCTAssertEqual(avengers.thumbnail, thumbnail)
        let issue = ComicModel(id: id, title: title, thumbnail: thumbnail)
        XCTAssert(avengers == issue)
    }

}
