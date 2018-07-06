//
//  CharacterVM.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 27/06/2018.
//

import Foundation

class CharacterVM: CharacterVMProtocol {
    
    var networkService: NetworkServiceProtocol?

    init() {
        privCurrentCharacter = CharacterModel(id: 0, name: "", thumbnail: ThumbnailModel(path: "", ext: ""), description: "")
    }
    
    let pageSize = 20
    
    private var privCurrentCharacter: CharacterModel
    var currentCharacter: CharacterModel {
        get { return privCurrentCharacter }
        set { privCurrentCharacter = newValue }
    }
    
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
        complete: @escaping ( ServiceResult<[CharacterModel]?> ) -> Void )  {
        let offset = page * pageSize
        guard let networkService = networkService else {
            return complete(.Error("Missing network service", 0))
        }
        let baseUrl = networkService.baseUrl
        let hash = networkService.apiKeyTsHash
        let url = "\(baseUrl)characters?\(hash)&offset=\(offset)&nameStartsWith=Spi"
        // TODO: filter: &nameStartsWith=Spi
        networkService.request(
            url: url,
            method: .get,
            parameters: nil
        ) { [weak self] (result) in
            if page == 0 {
                self?.privCharacterList.removeAll()
            }
            switch result {
            case .Success(let json, let statusCode):
                do {
                    if let data = json?.data(using: .utf8) {
                        let decoder = JSONDecoder()
                        let characterResponse = try decoder.decode(CharacterResponse.self, from: data)
                        self?.privCharacterList.append(contentsOf: characterResponse.data.results)
                        return complete(.Success(self?.privCharacterList, statusCode))
                    }
                    return complete(.Error("Error parsing data", statusCode))
                } catch {
                    print("error:\(error)")
                    return complete(.Error("Error decoding JSON", statusCode))
                }
            case .Error(let message, let statusCode):
                return complete(.Error(message, statusCode))
            }
        }
    }
    
    func getCharacterComics(
        page: Int,
        character: Int,
        complete: @escaping ( ServiceResult<[ComicModel]?> ) -> Void )  {
        let offset = page * pageSize
        guard let networkService = networkService else {
            return complete(.Error("Missing network service", 0))
        }
        let baseUrl = networkService.baseUrl
        let hash = networkService.apiKeyTsHash
        let url = "\(baseUrl)characters/\(character)/comics?\(hash)&offset=\(offset)"
        networkService.request(
            url: url,
            method: .get,
            parameters: nil
        ) { [weak self] (result) in
            if page == 0 {
                self?.privComicList.removeAll()
            }
            switch result {
            case .Success(let json, let statusCode):
                do {
                    if let data = json?.data(using: .utf8) {
                        let decoder = JSONDecoder()
                        let comicResponse = try decoder.decode(ComicResponse.self, from: data)
                        self?.privComicList.append(contentsOf: comicResponse.data.results)
                        return complete(.Success(self?.privComicList, statusCode))
                    }
                    return complete(.Error("Error parsing data", statusCode))
                } catch {
                    print("error:\(error)")
                    return complete(.Error("Error decoding JSON", statusCode))
                }
            case .Error(let message, let statusCode):
                return complete(.Error(message, statusCode))
            }
        }
    }
    
}

