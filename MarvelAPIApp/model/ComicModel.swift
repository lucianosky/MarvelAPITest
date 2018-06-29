//
//  ComicModel.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 29/06/2018.
//

import Foundation

class ComicModel {
    let title: String
    let imageURI: String?
    
    init(title: String, imageURI: String?) {
        self.title = title
        self.imageURI = imageURI
    }
}

extension ComicModel: Equatable {
    static func == (lhs: ComicModel, rhs: ComicModel) -> Bool {
        return lhs.title == rhs.title && lhs.imageURI == rhs.imageURI
    }
}
