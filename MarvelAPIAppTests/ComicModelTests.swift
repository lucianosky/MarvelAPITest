//
//  ComicModelTests.swift
//  MarvelAPIAppTests
//
//  Created by SoftDesign on 29/06/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import XCTest

@testable import MarvelAPIApp

class ComicModelTests: XCTestCase {
    
    func testInit() {
        let title = "Avengers: The Initiative"
        let imageURI = "http:\\..."
        
        let avengers = ComicModel(title: title, imageURI: nil)
        XCTAssertEqual(avengers.title, title)
        XCTAssertNil(avengers.imageURI)
        let issue2 = ComicModel(title: title, imageURI: imageURI)
        XCTAssertEqual(issue2.imageURI, imageURI)
    }

}
