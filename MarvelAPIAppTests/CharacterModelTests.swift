//
//  CharacterModelTest.swift
//  MarvelAPIAppTests
//
//  Created by SoftDesign on 28/06/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import XCTest

@testable import MarvelAPIApp

class CharacterModelTests: XCTestCase {
    
    func testInit() {
        let name = "Spider Man"
        let description = "Peter Parker's secret id"
        let imageURI = "http:\\..."
        let spiderMan = CharacterModel(name: name, imageURI: nil, description: description)
        XCTAssertEqual(spiderMan.name, name)
        XCTAssertEqual(spiderMan.description, description)
        XCTAssertNil(spiderMan.imageURI)
        let peterParker = CharacterModel(name: name, imageURI: imageURI, description: description)
        XCTAssertEqual(peterParker.imageURI, imageURI)
    }
    
    
}
