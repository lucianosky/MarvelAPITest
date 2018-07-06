//
//  MockNetworkServiceBugged.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 06/07/2018.
//

import Foundation
import Alamofire

@testable import MarvelAPIApp


class MockNetworkServiceBugged: NetworkServiceProtocol {
    
    var apiKeyTsHash: String { get { return "" } }
    
    var baseUrl: String { get { return "" } }
    
    var bugNotJSON = false
    
    func request(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        complete: @escaping ( ServiceResult<String?> ) -> Void )
    {
        if bugNotJSON {
            return complete(.Success("Not JSON!", 200))
        } else {
            return complete(.Error("Expected error", 0))
        }
    }
    
}
