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

    let pageSize = 20
    private var privCharacterList = [CharacterModel]()

    var characterList: [CharacterModel] {
        get {
            return privCharacterList
        }
    }

    func getCharacters(
        page: Int,
        complete: @escaping ( Result<[CharacterModel]?> ) -> Void )  {
        let offset = page * pageSize
        let url = "\(NetworkService.shared.baseUrl)characters?\(NetworkService.shared.apiKeyTsHash)&offset=\(offset)"
        NetworkService.shared.request(
            url: url
        ) { [weak self] (result) in
            switch result {
            case .Success(let resultsDict, let statusCode):
                if let results = resultsDict {
                    var list = [CharacterModel]()
                    results.forEach({ (character) in
                        if let name = character["name"] as? String,
                            let thumbnail = character["thumbnail"] as? [String: Any],
                            let path = thumbnail["path"] as? String,
                            let ext = thumbnail["extension"] as? String
                        {
                            let imageURI = path + "." + ext
                            list.append(CharacterModel(name: name, imageURI: imageURI))
                        } else {
                            print("error reading character")
                        }
                    })
                    self?.privCharacterList.append(contentsOf: list)
                }
                return complete(.Success(self?.characterList, statusCode))
            case .Error(let message, let statusCode):
                return complete(.Error(message, statusCode))
            }
        }
    }

}
