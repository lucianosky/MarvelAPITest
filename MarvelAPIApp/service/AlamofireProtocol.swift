//
//  AlamofireProtocol.swift
//  MarvelAPIApp
//
//  Created by SoftDesign on 30/07/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import Foundation
import Alamofire

protocol AlamofireProtocol {
    
    func responseString(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        completionHandler: @escaping (DataResponse<String>) -> Void
    )

}
