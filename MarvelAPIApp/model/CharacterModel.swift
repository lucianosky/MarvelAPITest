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
    
    init(id: Int, name: String, thumbnail: ThumbnailModel, description: String) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
    }
}

class CharacterData: Decodable {
    let results: [CharacterModel]
}

class CharacterResponse: Decodable {
    let data: CharacterData
}

extension CharacterModel: Equatable {
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.thumbnail == rhs.thumbnail &&
               lhs.description == rhs.description
    }
}
