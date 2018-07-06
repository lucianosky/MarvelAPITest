//
//  NetworkServiceProtocol.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 05/07/2018.
//

import Alamofire

enum ServiceResult<T> {
    case Success(T, Int)
    case Error(String, Int?)
}

protocol NetworkServiceProtocol {

    var apiKeyTsHash: String { get }
    
    var baseUrl: String { get }

    func request(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        complete: @escaping ( ServiceResult<String?> ) -> Void )
    
}
