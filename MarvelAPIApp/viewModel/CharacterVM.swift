//
//  CharacterVM.swift
//  MarvelAPIApp
//
//  Created by SoftDesign on 27/06/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import Foundation

class CharacterVM {
    
    static let shared = CharacterVM()
    private init() {} // singleton

    var characterList = [CharacterModel]()
    
    func getCharacters(
        complete: @escaping ( Result<[CharacterModel]?> ) -> Void )  {
        let url = "\(NetworkService.shared.baseUrl)characters?\(NetworkService.shared.apiKeyTsHash)&nameStartsWith=spi"
        print(url)
        NetworkService.shared.request(
            url: url
        ) { [weak self] (result) in
            switch result {
            case .Success(let xyz, let statusCode):
                guard let adata = xyz?["data"] as? [String: Any],
                    let results = adata["results"] as? [[String: Any]]
                    else {
                        let msg = "characters data null"
                        return complete(.Error(msg, statusCode))
                }
                self?.characterList = results.map({ (character) -> CharacterModel in
                    let name = (character["name"] as? String ?? "Erro").lowercased()
                    var imageURI: String?
                    if let thumbnail = character["thumbnail"] as? [String: Any],
                        let path = thumbnail["path"] as? String,
                        let ext = thumbnail["extension"] as? String {
                        imageURI = path + "." + ext
                    } else {
                        print("deu erro")
                    }
                    return CharacterModel(name: name, imageURI: imageURI)
                })
                return complete(.Success(self?.characterList, statusCode))
            case .Error(let message, let statusCode):
                return complete(.Error(message, statusCode))
            }
        }
    }

}
