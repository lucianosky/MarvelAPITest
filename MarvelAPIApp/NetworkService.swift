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
    private init() {} // singleton

    private let verbose = true

    private func verbosePrint(_ msg: String) {
        if verbose {
            print(msg)
        }
    }
    
    private var manager: Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "gateway.marvel.com": .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return manager
    }()

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

        print("oioi NetworkService REAL")

        let request = manager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
        request.responseString { [weak self] response in
            self?.verbosePrint("url=\(response.request?.url?.description ?? "")")
            let statusCode = response.response?.statusCode ?? -1
            self?.verbosePrint("status code=\(statusCode)")
            if response.result.isSuccess {
                return complete(.Success(response.result.value, statusCode))

            } else {
                request.responseString(completionHandler: { (strResponse) in
                    return complete(.Error(self?.treatError(url: url, response: strResponse) ?? "", response.response?.statusCode))
                })
            }
        }
    }
}
