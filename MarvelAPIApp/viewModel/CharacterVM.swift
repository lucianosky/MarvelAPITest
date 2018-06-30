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
        privCurrentCharacter = CharacterModel(id: 0, name: "", imageURI: nil, description: "")
    }
    
    let pageSize = 20

    private var privCharacterList = [CharacterModel]()
    var characterList: [CharacterModel] {
        get { return privCharacterList }
    }

    private var privComicList = [ComicModel]()
    var comicList: [ComicModel] {
        get { return privComicList }
    }

    func getCharacters(
        page: Int,
        complete: @escaping ( Result<[CharacterModel]?> ) -> Void )  {
        let offset = page * pageSize
        let baseUrl = NetworkService.shared.baseUrl
        let hash = NetworkService.shared.apiKeyTsHash
        let url = "\(baseUrl)characters?\(hash)&offset=\(offset)&nameStartsWith=Spi"
        // TODO: filter: &nameStartsWith=Spi
        NetworkService.shared.request(
            url: url
        ) { [weak self] (result) in
            if page == 0 {
                self?.privCharacterList.removeAll()
            }
            switch result {
            case .Success(let resultsDict, _):
                var list = [CharacterModel]()
                if let results = resultsDict {
                    results.forEach({ (character) in
                        if  let id = character["id"] as? Int,
                            let name = character["name"] as? String,
                            let thumbnail = character["thumbnail"] as? [String: Any],
                            let path = thumbnail["path"] as? String,
                            let ext = thumbnail["extension"] as? String,
                            let description = character["description"] as? String
                        {
                            let imageURI = path + "." + ext
                            list.append(CharacterModel(id: id, name: name, imageURI: imageURI, description: description))
                        } else {
                            print("error reading character")
                        }
                    })
                    self?.privCharacterList.append(contentsOf: list)
                }
                return complete(.Success(self?.privCharacterList, list.count))
            case .Error(let message, let statusCode):
                return complete(.Error(message, statusCode))
            }
        }
    }

    func getCharacterComics(
        page: Int,
        character: Int,
        complete: @escaping ( Result<[ComicModel]?> ) -> Void )  {
        let offset = page * pageSize
        let baseUrl = NetworkService.shared.baseUrl
        let hash = NetworkService.shared.apiKeyTsHash
        let url = "\(baseUrl)characters/\(character)/comics?\(hash)&offset=\(offset)"
        NetworkService.shared.request(
            url: url
        ) { [weak self] (result) in
            if page == 0 {
                self?.privComicList.removeAll()
            }
            switch result {
            case .Success(let resultsDict, _):
                var list = [ComicModel]()
                if let results = resultsDict {
                    results.forEach({ (character) in
                        if  let id = character["id"] as? Int,
                            let title = character["title"] as? String,
                            let thumbnail = character["thumbnail"] as? [String: Any],
                            let path = thumbnail["path"] as? String,
                            let ext = thumbnail["extension"] as? String
                        {
                            let imageURI = path + "." + ext
                            list.append(ComicModel(id: id, title: title, imageURI: imageURI))
                        } else {
                            print("error reading comic")
                        }
                    })
                    self?.privComicList.append(contentsOf: list)
                }
                return complete(.Success(self?.privComicList, list.count))
            case .Error(let message, let statusCode):
                return complete(.Error(message, statusCode))
            }
        }
    }
    
}
