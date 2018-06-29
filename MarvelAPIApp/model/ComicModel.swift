//
//  ComicModel.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 29/06/2018.
//

import Foundation

class ComicModel {
    let id: Int
    let title: String
    let imageURI: String?
    
    init(id: Int, title: String, imageURI: String?) {
        self.id = id
        self.title = title
        self.imageURI = imageURI
    }
}

extension ComicModel: Equatable {
    static func == (lhs: ComicModel, rhs: ComicModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.imageURI == rhs.imageURI
    }
}
