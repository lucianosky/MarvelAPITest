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
        let imageURI = "http:\\..."
        
        let avengers = ComicModel(id: id, title: title, imageURI: nil)
        XCTAssertEqual(avengers.title, title)
        XCTAssertNil(avengers.imageURI)
        let issue2 = ComicModel(id: id, title: title, imageURI: imageURI)
        XCTAssertEqual(issue2.imageURI, imageURI)
        let issue2Copy = ComicModel(id: id, title: title, imageURI: imageURI)
        XCTAssert(issue2 == issue2Copy)
    }

}
