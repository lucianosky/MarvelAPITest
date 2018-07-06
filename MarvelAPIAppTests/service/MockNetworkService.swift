//
//  MockNetworkService.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 05/07/2018.
//

import Foundation
import Alamofire

@testable import MarvelAPIApp

class MockNetworkService: NetworkServiceProtocol {

    var apiKeyTsHash: String {
        get { return "key" }
    }
    
    var baseUrl: String {
        get { return "url://" }
    }

    private func returnContentsOfJsonFile(named name: String) -> String? {
        let testBundle = Bundle(for: type(of: self))
        if let fileURL = testBundle.url(forResource: name, withExtension: "json") {
            do {
                return try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {
                return nil
            }
        }
        return nil
    }
    
    func request(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        complete: @escaping ( ServiceResult<String?> ) -> Void ) {
        if url == "url://characters?key&offset=0" || url == "url://characters?key&offset=0&nameStartsWith=Spi" {
            if let text = returnContentsOfJsonFile(named: "characters") {
                return complete(.Success(text, 200))
            } else {
                return complete(.Error("error in request", 0))
            }
        } else if url == "url://characters/1009610/comics?key&offset=0" {
            if let text = returnContentsOfJsonFile(named: "comics") {
                return complete(.Success(text, 200))
            } else {
                return complete(.Error("error in request", 0))
            }
        }
        return complete(.Error("error in URL", 0))
    }
    
}

