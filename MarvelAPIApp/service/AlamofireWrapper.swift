//
//  AlamofireExtension.swift
//  MarvelAPIApp
//
//  Created by SoftDesign on 30/07/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import Alamofire
import Foundation

class AlamofireWrapper: AlamofireProtocol {

    var manager: Alamofire.SessionManager
    
    init() {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "gateway.marvel.com": .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
    
    func responseString(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        completionHandler: @escaping (DataResponse<String>) -> Void
    ) {
        manager.request(url, method: method, parameters: parameters, encoding: encoding).responseString(completionHandler: completionHandler)
    }

}
