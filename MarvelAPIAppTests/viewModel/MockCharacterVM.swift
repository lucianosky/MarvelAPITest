//
//  MockCharacterVM.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 03/07/2018.
//

import Foundation

@testable import MarvelAPIApp

class MockCharacterVM: CharacterVMProtocol {
    
    private var privCharacterList = [CharacterModel]()
    private var privComicList = [ComicModel]()
    private var delay = true
    private var privCurrentCharacter: CharacterModel

    // we need a delay to test the loadingCell, with its own delay on the test
    private let delaySeconds = 4
    static let pageSize = 20

    init(delay: Bool) {
        self.delay = delay
        privCurrentCharacter = CharacterModel(id: 0, name: "", imageURI: nil, description: "")
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
    
    var characterList: [CharacterModel] {
        get { return privCharacterList }
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
    
    var currentCharacter: CharacterModel {
        get { return privCurrentCharacter }
        set { privCurrentCharacter = newValue }
    }
    
    var comicList: [ComicModel] {
        get { return privComicList }
    }
    
    func getCharacterComics(
        page: Int,
        character: Int,
        complete: @escaping ( Result<[ComicModel]?> ) -> Void ) {
        return complete(.Success([], 0))
    }



}
