//
//  CharacterModelTest.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 28/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterModelTests: XCTestCase {
    
    func testInit() {
        let id = 1000
        let name = "Spider Man"
        let description = "Peter Parker's secret id"
        let thumbnail = ThumbnailModel(path: "path", ext: "ext")
        let spiderMan = CharacterModel(id: id, name: name, thumbnail: thumbnail, description: description)
        XCTAssertEqual(spiderMan.id, id)
        XCTAssertEqual(spiderMan.name, name)
        XCTAssertEqual(spiderMan.thumbnail, thumbnail)
        XCTAssertEqual(spiderMan.description, description)
        let peterParker = CharacterModel(id: id, name: name, thumbnail: thumbnail, description: description)
        XCTAssert(spiderMan == peterParker)
    }
    
}
