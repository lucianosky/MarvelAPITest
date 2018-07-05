//
//  CharacterModel.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 27/06/2018.
//

import Foundation

class CharacterModel: Decodable {
    let id: Int
    let name: String
    let thumbnail: ThumbnailModel
    let description: String
    
    init(id: Int, name: String, imageURI: ThumbnailModel, description: String) {
        self.id = id
        self.name = name
        self.thumbnail = imageURI
        self.description = description
    }
}

class CharacterData: Decodable {
    let results: [CharacterModel]
    
    init(results: [CharacterModel]) {
        self.results = results
    }
}

class CharacterResponse: Decodable {
    let data: CharacterData
    
    init(data: CharacterData) {
        self.data = data
    }
}

extension CharacterModel: Equatable {
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.thumbnail == rhs.thumbnail &&
               lhs.description == rhs.description
    }
}
