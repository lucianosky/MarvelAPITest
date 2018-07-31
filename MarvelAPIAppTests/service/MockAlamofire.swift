//
//  MockAlamofire.swift
//  MarvelAPIAppTests
//
//  Created by SoftDesign on 30/07/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import Foundation
import Alamofire
@testable import MarvelAPIApp

class MockAlamofire: AlamofireProtocol {
    
    var resultString: String = "the test"
    
    func responseString(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        completionHandler: @escaping (DataResponse<String>) -> Void)
    {
        let httpResponse = HTTPURLResponse(url: NSURL(string: "myurl")! as URL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        let result = Result<String>.success(resultString)
        let dataResponse = DataResponse(request: NSURLRequest() as URLRequest, response: httpResponse, data: NSData() as Data, result: result)
        completionHandler(dataResponse)
    }
    
}
