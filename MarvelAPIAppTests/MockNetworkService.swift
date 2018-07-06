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
        get { return "" }
    }
    
    var baseUrl: String {
        get { return "" }
    }
    
    func request(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        complete: @escaping ( ServiceResult<String?> ) -> Void ) {

        print("oioi MockNetworkService")
        
        //if url == "" {
        
            let testBundle = Bundle(for: type(of: self))
//          if let filePath = testBundle.path(forResource: "characters", ofType: "json") {
            if let fileURL = testBundle.url(forResource: "characters", withExtension: "json") {
                do {
                    print("oioi MockNetworkService return")
                    let value = try String(contentsOf: fileURL, encoding: .utf8)
                    return complete(.Success(value, 200))
                }
                catch {
                    return complete(.Error("error", 0))
                    
                }
            }
        return complete(.Error("error", 0))
//        } else {
//            return nil
//        }
        
    }
    
}

