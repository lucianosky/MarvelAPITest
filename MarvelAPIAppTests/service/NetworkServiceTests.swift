//
//  NetworkServiceTest.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 28/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class NetworkServiceTests: XCTestCase {
    
    var mockAlamofire: MockAlamofire!
    
    override func setUp() {
        super.setUp()
        mockAlamofire = MockAlamofire()
        NetworkService.shared.alamofireWrapper = mockAlamofire
    }
    
    override func tearDown() {
        mockAlamofire = nil
    }

    func testRequest() {
        let expected = "expected"
        mockAlamofire.resultString = expected
        let promise = expectation(description: "testRequest")
        NetworkService.shared.request(url: "url", method: .get, parameters: nil) { (result) in
            switch result {
            case .Success(let str, let statusCode):
                if statusCode == 200 {
                    XCTAssertEqual(str, expected)
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            case .Error(let message, let statusCode):
                XCTFail("Error: statusCode=\(statusCode ?? -1) \(message)")
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testNoAlamofireWrapper() {
        mockAlamofire = nil
        NetworkService.shared.alamofireWrapper = nil
        let promise = expectation(description: "testNoAlamofireWrapper")
        NetworkService.shared.request(url: "url", method: .get, parameters: nil) { (result) in
            switch result {
            case .Success(let str, let statusCode):
                XCTFail("Error: statusCode=\(statusCode) \(str ?? "")")
            case .Error(_, _):
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testResponseError() {
        let promise = expectation(description: "testResponseError")
        mockAlamofire.isSuccess = false
        NetworkService.shared.request(url: "url", method: .get, parameters: nil) { (result) in
            switch result {
            case .Success(let str, let statusCode):
                XCTFail("Error: statusCode=\(statusCode) \(str ?? "")")
            case .Error(_, _):
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
