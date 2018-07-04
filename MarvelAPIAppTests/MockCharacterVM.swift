//
//  MockCharacterVM.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 03/07/2018.
//

import Foundation

@testable import MarvelAPIApp

class MockCharacterVM: CharacterVMProtocol {
    
    var privCharacterList = [CharacterModel]()
    private var delay = true
    
    // we need a delay to test the loadingCell, with its own delay on the test
    private let delaySeconds = 4
    static let pageSize = 20

    init(delay: Bool) {
        self.delay = delay
    }

    private func createCharacter(id: Int) -> CharacterModel {
        return CharacterModel(id: id,
                              name: "Spiderman\(id)",
                              imageURI: "http://i.annihil.us/u/prod/marvel/i/mg/3/50/526548a343e4b.jpg",
                              description: "Description \(id)")
    }
    
    private func createCharacterPage(from: Int, pageSize: Int) {
        let range = from..<from+pageSize
        range.forEach({ (id) in
            self.privCharacterList.append(createCharacter(id: id))
        })
    }
    
    func getCharacterList() -> [CharacterModel] {
        return privCharacterList
    }
    
    func getCharacters(page: Int, complete: @escaping (Result<[CharacterModel]?>) -> Void) {
        if page == 0 {
            privCharacterList.removeAll()
            createCharacterPage(from: 0, pageSize: MockCharacterVM.pageSize)
        } else if page == 1 {
            createCharacterPage(from: MockCharacterVM.pageSize, pageSize: MockCharacterVM.pageSize)
        }
        if delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delaySeconds), execute: {
                return complete(.Success(self.privCharacterList, 0))
            })
        } else {
            return complete(.Success(self.privCharacterList, 0))
        }
    }

}
