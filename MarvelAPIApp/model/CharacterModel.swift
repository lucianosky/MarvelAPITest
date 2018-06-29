//
//  CharacterModel.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 27/06/2018.
//

import Foundation

class CharacterModel {
    let id: Int
    let name: String
    let imageURI: String?
    let description: String
    
    init(id: Int, name: String, imageURI: String?, description: String) {
        self.id = id
        self.name = name
        self.imageURI = imageURI
        self.description = description
    }
}

extension CharacterModel: Equatable {
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.imageURI == rhs.imageURI &&
               lhs.description == rhs.description
    }
}
