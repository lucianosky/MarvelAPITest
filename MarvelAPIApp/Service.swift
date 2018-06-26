//
//  Service.swift
//  MarvelAPIApp
//
//  Created by SoftDesign on 25/06/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
    case Success(T, Int)
    case Error(String, Int?)
}

struct CharacterModel {
    let name: String
    let imageURI: String?
}

class NetworkService {
    
    static let shared = NetworkService()
    private init() {} // singleton

    private let verbose = true

    private func verbosePrint(_ msg: String) {
        if verbose {
            print("Service: \(msg)")
        }
    }
    
    var characterList = [CharacterModel]()
    
    private func treatError(url: String, response: DataResponse<String>) -> String{
        verbosePrint("error=\(response.description)")
        if let localizedDescription = response.result.error?.localizedDescription {
            return localizedDescription
        } else if response.result.debugDescription.count > 0 {
            return response.result.debugDescription
        }
        return  "error: \(response.response?.statusCode ?? 0)"
    }
    
    private func basicCall(
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        complete: @escaping ( Result<[String: Any]?> ) -> Void )
    {
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
        request.responseJSON { response in
            self.verbosePrint("url=\(response.request?.url?.description ?? "")")
            let statusCode = response.response?.statusCode ?? -1
            self.verbosePrint("status code=\(statusCode)")
            if response.result.isSuccess {
                //return complete(.Success(response.result.value, statusCode))
                if let array = response.result.value as? [String: Any] {
                    return complete(.Success(array, statusCode))
                } else {
                    return complete(.Success(nil, statusCode))
                }
            } else {
                request.responseString(completionHandler: { (strResponse) in
                    return complete(.Error(self.treatError(url: url, response: strResponse), response.response?.statusCode))
                })
            }
        }
    }
    
    func characters(
        complete: @escaping ( Result<[CharacterModel]?> ) -> Void )  {
            let url = "https://gateway.marvel.com/v1/public/characters?apikey=cdb9b66985f6523d88b3b820037f895f&ts=1529959176&hash=fc9bc3330d53b8b9d28c88aa707473b7&nameStartsWith=spi"
            basicCall(
                url: url
            ) { (result) in
                switch result {
                case .Success(let xyz, let statusCode):
                    guard let adata = xyz?["data"] as? [String: Any],
                         let results = adata["results"] as? [[String: Any]]
                    else {
                        let msg = "characters data null"
                        return complete(.Error(msg, statusCode))
                    }
                    self.characterList = results.map({ (character) -> CharacterModel in
                        let name = (character["name"] as? String ?? "Erro").lowercased()
                        var imageURI: String?
                        if let thumbnail = character["thumbnail"] as? [String: Any],
                           let path = thumbnail["path"] as? String,
                            let ext = thumbnail["extension"] as? String {
                            imageURI = path + "." + ext
                            print(imageURI)
                        } else {
                            print("deu erro")
                        }
                        return CharacterModel(name: name, imageURI: imageURI)
                    })
                    return complete(.Success(self.characterList, statusCode))
                case .Error(let message, let statusCode):
                    return complete(.Error(message, statusCode))
                }
            }
        }

}
