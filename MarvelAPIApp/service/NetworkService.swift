//
//  Service.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 25/06/2018.
//

import Foundation
import Alamofire

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()

    // singleton
    private init() {}
    
    var alamofireWrapper: AlamofireProtocol?

    private let verbose = true

    private func verbosePrint(_ msg: String) {
        if verbose {
            print(msg)
        }
    }
    
    var apiKeyTsHash: String {
        get {
            let apikey = "cdb9b66985f6523d88b3b820037f895f"
            let ts = "1529959176"
            let hash = "fc9bc3330d53b8b9d28c88aa707473b7"
            return "apikey=\(apikey)&ts=\(ts)&hash=\(hash)"
        }
    }
    
    var baseUrl: String {
        get {
            return "https://gateway.marvel.com/v1/public/"
        }
    }
    
    private func treatError(url: String, response: DataResponse<String>) -> String{
        verbosePrint("error=\(response.description)")
        if let localizedDescription = response.result.error?.localizedDescription {
            return localizedDescription
        } else if response.result.debugDescription.count > 0 {
            return response.result.debugDescription
        }
        return "error: \(response.response?.statusCode ?? 0)"
    }
    
    func request(
        url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        complete: @escaping ( ServiceResult<String?> ) -> Void )
    {
        guard let wrapper = alamofireWrapper else {
            return complete(.Error("Error creating request", 0))
        }

        wrapper.responseString(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
        { [weak self] response in
            self?.verbosePrint("url=\(response.request?.url?.description ?? "")")
            let statusCode = response.response?.statusCode ?? -1
            self?.verbosePrint("status code=\(statusCode)")
            if response.result.isSuccess {
                return complete(.Success(response.result.value, statusCode))
                
            }
            return complete(.Error(self?.treatError(url: url, response: response) ?? "", response.response?.statusCode))
        }

    }
}
