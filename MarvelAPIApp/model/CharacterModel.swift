//
//  CharacterModel.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 27/06/2018.
//

import Foundation

class CharacterModel {
    let name: String
    let imageURI: String?
    let description: String
    
    init(name: String, imageURI: String?, description: String) {
        self.name = name
        self.imageURI = imageURI
        self.description = description
    }
}

extension CharacterModel: Equatable {
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        return lhs.name == rhs.name && lhs.imageURI == rhs.imageURI && lhs.description == rhs.description
    }
}
