//
//  CharacterVM.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 27/06/2018.
//

import Foundation

class CharacterVM {
    
    static let shared = CharacterVM()
    
    private var privCurrentCharacter: CharacterModel
    private init() { // singleton
        privCurrentCharacter = CharacterModel(name: "", imageURI: nil)
    }
    
    let pageSize = 20
    private var privCharacterList = [CharacterModel]()
    
    
    var characterList: [CharacterModel] {
        get {
            return privCharacterList
        }
    }
    
    var currentCharacter: CharacterModel {
        get {
            return privCurrentCharacter
        }
        set {
            privCurrentCharacter = newValue
        }
    }

    func getCharacters(
        page: Int,
        complete: @escaping ( Result<[CharacterModel]?> ) -> Void )  {
        let offset = page * pageSize
        let url = "\(NetworkService.shared.baseUrl)characters?\(NetworkService.shared.apiKeyTsHash)&offset=\(offset)"
        // TODO: filter: &nameStartsWith=Spi
        NetworkService.shared.request(
            url: url
        ) { [weak self] (result) in
            switch result {
            case .Success(let resultsDict, _):
                var list = [CharacterModel]()
                if let results = resultsDict {
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
                return complete(.Success(self?.characterList, list.count))
            case .Error(let message, let statusCode):
                return complete(.Error(message, statusCode))
            }
        }
    }

}
