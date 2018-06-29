//
//  CharacterVMTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 28/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterVMTests: XCTestCase {
    
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

    func testGetCharacterComics() {
        let promise = expectation(description: "...")
        let spiderManId = 1009610
        CharacterVM.shared.getCharacterComics(page: 0, character: spiderManId) { (result) in
            switch result {
            case .Success(let comicList, let count):
                XCTAssertEqual(count, 20)
                XCTAssertEqual(count, CharacterVM.shared.comicList.count)
                let firstComic = comicList![0]
                XCTAssertEqual(firstComic.title, "Peter Parker: Spider-Man (1999) #79")
                promise.fulfill()
            case .Error(let message, let statusCode):
                XCTFail("Error: statusCode=\(statusCode ?? -1) \(message)")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

}
