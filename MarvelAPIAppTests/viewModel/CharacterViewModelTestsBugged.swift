//
//  CharacterViewModelTestsBugged.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 06/07/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterViewModelTestsBugged: XCTestCase {
    
    private var characterViewModel: CharacterViewModel!
    private var mockNetworkServiceBugged: NetworkServiceProtocol!
    
    override func setUp() {
        super.setUp()
        mockNetworkServiceBugged = MockNetworkServiceBugged()
        characterViewModel = CharacterViewModel()
        characterViewModel.networkService = mockNetworkServiceBugged
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Mark: response not JSON
    
    func testGetCharactersNotJSON() {
        (mockNetworkServiceBugged as! MockNetworkServiceBugged).bugNotJSON = true
        let promise = expectation(description: "testGetCharactersNotJSON")
        characterViewModel.getCharacters(page: 0) { (result) in
            switch result {
            case .Success(_, _):
                XCTFail("Expected failure")
            case .Error(let message, _):
                XCTAssertEqual(message, "Error decoding JSON")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetCharacterComicsNotJSON() {
        (mockNetworkServiceBugged as! MockNetworkServiceBugged).bugNotJSON = true
        let promise = expectation(description: "testGetCharacterComicsNotJSON")
        characterViewModel.getCharacterComics(page: 0, character: 0) { (result) in
            switch result {
            case .Success(_, _):
                XCTFail("Expected failure")
            case .Error(let message, _):
                XCTAssertEqual(message, "Error decoding JSON")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    // Mark: response null
    
    func testGetCharactersNull() {
        (mockNetworkServiceBugged as! MockNetworkServiceBugged).bugNull = true
        let promise = expectation(description: "testGetCharactersNull")
        characterViewModel.getCharacters(page: 0) { (result) in
            switch result {
            case .Success(_, _):
                XCTFail("Expected failure")
            case .Error(let message, _):
                XCTAssertEqual(message, "Error parsing data")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCharacterComicsNull() {
        (mockNetworkServiceBugged as! MockNetworkServiceBugged).bugNull = true
        let promise = expectation(description: "testGetCharactersNull")
        characterViewModel.getCharacterComics(page: 0, character: 0) { (result) in
            switch result {
            case .Success(_, _):
                XCTFail("Expected failure")
            case .Error(let message, _):
                XCTAssertEqual(message, "Error parsing data")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: response with error
    
    func testGetCharactersError() {
        let promise = expectation(description: "testGetCharactersError")
        characterViewModel.getCharacters(page: 0) { (result) in
            switch result {
            case .Success(_, _):
                XCTFail("Expected failure")
            case .Error(let message, _):
                XCTAssertEqual(message, "Expected error")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCharacterComicsError() {
        let promise = expectation(description: "testGetCharacterComicsError")
        characterViewModel.getCharacterComics(page: 0, character: 0) { (result) in
            switch result {
            case .Success(_, _):
                XCTFail("Expected failure")
            case .Error(let message, _):
                XCTAssertEqual(message, "Expected error")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: no network service

    func testGetCharactersNoService() {
        characterViewModel.networkService = nil
        let promise = expectation(description: "testGetCharactersNoService")
        characterViewModel.getCharacters(page: 0) { (result) in
            switch result {
            case .Success(_, _):
                XCTFail("Expected failure")
            case .Error(let message, _):
                XCTAssertEqual(message, "Missing network service")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCharacterComicsNoService() {
        characterViewModel.networkService = nil
        let promise = expectation(description: "testGetCharacterComicsNoService")
        characterViewModel.getCharacterComics(page: 0, character: 0) { (result) in
            switch result {
            case .Success(_, _):
                XCTFail("Expected failure")
            case .Error(let message, _):
                XCTAssertEqual(message, "Missing network service")
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
