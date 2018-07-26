//
//  CharacterViewModelTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 28/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterViewModelTests: XCTestCase {
    
    private var characterViewModel: CharacterViewModel!
    private var mockNetworkService: NetworkServiceProtocol!

    override func setUp() {
        super.setUp()
        mockNetworkService  = MockNetworkService()
        characterViewModel = CharacterViewModel()
        characterViewModel.networkService = mockNetworkService
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCurrentCharacter() {
        let thumbnail = ThumbnailModel(path: "path", ext: "ext")
        let currentCharacter = CharacterModel(id: 1, name: "name", thumbnail: thumbnail, description: "description")
        characterViewModel.currentCharacter = currentCharacter
        let currentCharacterCopy = characterViewModel.currentCharacter
        XCTAssertEqual(currentCharacter, currentCharacterCopy)
    }
    
    func testGetCharacters() {
        let promise = expectation(description: "testGetCharacters")
        characterViewModel.getCharacters(page: 0) { (result) in
            switch result {
            case .Success(let characterList, _):
                XCTAssertEqual(characterList?.count, 20)
                XCTAssertEqual(characterList?.count, self.characterViewModel.characterList.count)
                let t3dMan = characterList![0]
                XCTAssertEqual(t3dMan.name, "Spider-dok")
                promise.fulfill()
            case .Error(let message, let statusCode):
                XCTFail("Error: statusCode=\(statusCode ?? -1) \(message)")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetCharacterComics() {
        let promise = expectation(description: "testGetCharacterComics")
        let spiderManId = 1009610
        characterViewModel.getCharacterComics(page: 0, character: spiderManId) { (result) in
            switch result {
            case .Success(let comicList, _):
                XCTAssertEqual(comicList?.count, 20)
                XCTAssertEqual(comicList?.count, self.characterViewModel.comicList.count)
                let firstComic = comicList![0]
                XCTAssertEqual(firstComic.title, "Peter Parker: Spider-Man (1999) #79")
                promise.fulfill()
            case .Error(let message, let statusCode):
                XCTFail("Error: statusCode=\(statusCode ?? -1) \(message)")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

}
