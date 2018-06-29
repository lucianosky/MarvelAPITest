//
//  NetworkServiceTest.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 28/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class NetworkServiceTests: XCTestCase {
    
    func testRequest() {
        let offset = 0
        let url = "\(NetworkService.shared.baseUrl)characters?\(NetworkService.shared.apiKeyTsHash)&offset=\(offset)&nameStartsWith=Spi"
        let promise = expectation(description: "Status code 200")
        NetworkService.shared.request(url: url) { (result) in
            switch result {
            case .Success(_, let statusCode):
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            case .Error(let message, let statusCode):
                XCTFail("Error: statusCode=\(statusCode ?? -1) \(message)")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInvalidURL() {
        let url = "\\InvalidURL"
        let promise = expectation(description: "Failure")
        NetworkService.shared.request(url: url) { (result) in
            switch result {
            case .Success(_, let statusCode):
                XCTFail("Status code: \(statusCode)")
            case .Error(_, _):
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
