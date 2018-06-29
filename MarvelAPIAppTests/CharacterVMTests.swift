//
//  CharacterVMTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 28/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterVMTests: XCTestCase {
    
    func testCurrentCharacter() {
        let name = "Spider Man"
        let description = "Peter Parker's secret id"
        let spiderMan = CharacterModel(name: name, imageURI: nil, description: description)
        CharacterVM.shared.currentCharacter = spiderMan
        let peterParker = CharacterVM.shared.currentCharacter
        XCTAssertEqual(spiderMan, peterParker)
        XCTAssert(spiderMan === peterParker)
    }
    
    func testGetCharacters() {
        let promise = expectation(description: "...")
        CharacterVM.shared.getCharacters(page: 0) { (result) in
            switch result {
            case .Success(let characterList, let count):
                XCTAssertEqual(count, 20)
                XCTAssertEqual(count, CharacterVM.shared.characterList.count)
                let t3dMan = characterList![0]
                XCTAssertEqual(t3dMan.name, "3-D Man")
                promise.fulfill()
            case .Error(let message, let statusCode):
                XCTFail("Error: statusCode=\(statusCode ?? -1) \(message)")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
