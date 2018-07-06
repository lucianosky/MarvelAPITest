//
//  ComicModel.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 29/06/2018.
//

import Foundation

class ComicModel: Decodable {
    let id: Int
    let title: String
    let thumbnail: ThumbnailModel
    
    init(id: Int, title: String, thumbnail: ThumbnailModel) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
    }
}

extension ComicModel: Equatable {
    static func == (lhs: ComicModel, rhs: ComicModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.thumbnail == rhs.thumbnail
    }
}

class ComicData: Decodable {
    let results: [ComicModel]
}

class ComicResponse: Decodable {
    let data: ComicData
}
