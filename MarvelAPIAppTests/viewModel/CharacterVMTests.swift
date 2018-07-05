//
//  CharacterVMTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 28/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterVMTests: XCTestCase {
    
    private var characterVM: CharacterVM!

    override func setUp() {
        super.setUp()
        characterVM = CharacterVM()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGetCharacters() {
        let promise = expectation(description: "...")
        characterVM.getCharacters(page: 0) { (result) in
            switch result {
            case .Success(let characterList, let count):
                XCTAssertEqual(count, 20)
                XCTAssertEqual(count, self.characterVM.characterList.count)
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
        characterVM.getCharacterComics(page: 0, character: spiderManId) { (result) in
            switch result {
            case .Success(let comicList, let count):
                XCTAssertEqual(count, 20)
                XCTAssertEqual(count, self.characterVM.comicList.count)
                let firstComic = comicList![0]
                XCTAssertEqual(firstComic.title, "Marvel Age Spider-Man Vol. 2: Everyday Hero (Digest)")
                promise.fulfill()
            case .Error(let message, let statusCode):
                XCTFail("Error: statusCode=\(statusCode ?? -1) \(message)")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

}