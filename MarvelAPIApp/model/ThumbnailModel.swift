//
//  ImageURIModel.swift
//  MarvelAPIApp
//
//  Created by SoftDesign on 05/07/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import Foundation

class ThumbnailModel: Decodable {
    let path: String
    let ext: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
    
    init(path: String, ext: String) {
        self.path = path
        self.ext = ext
    }
    
    required init(from decoder: Decoder) throws {
        let allValues = try decoder.container(keyedBy: CodingKeys.self)
        path = try allValues.decode(String.self, forKey: .path)
        ext = try allValues.decode(String.self, forKey: .ext)
    }
    
    var fullName: String {
        get { return path + "." + ext }
    }

}

extension ThumbnailModel: Equatable {
    static func == (lhs: ThumbnailModel, rhs: ThumbnailModel) -> Bool {
        return lhs.path == rhs.path &&
            lhs.ext == rhs.ext
    }
}
