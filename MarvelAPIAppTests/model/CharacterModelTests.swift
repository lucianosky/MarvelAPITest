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
        let imageURI = "http:\\..."
        let spiderMan = CharacterModel(id: id, name: name, imageURI: nil, description: description)
        XCTAssertEqual(spiderMan.id, id)
        XCTAssertEqual(spiderMan.name, name)
        XCTAssertEqual(spiderMan.description, description)
        XCTAssertNil(spiderMan.imageURI)
        let peterParker = CharacterModel(id: id, name: name, imageURI: imageURI, description: description)
        XCTAssertEqual(peterParker.imageURI, imageURI)
        let spiderManCopy = CharacterModel(id: id, name: name, imageURI: nil, description: description)
        XCTAssert(spiderMan == spiderManCopy)
    }
    
}
