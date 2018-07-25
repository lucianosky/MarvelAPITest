//
//  MockCharacterViewModel.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 03/07/2018.
//

import Foundation

@testable import MarvelAPIApp

class MockCharacterViewModel: CharacterViewModelProtocol {
    
    private var privCharacterList = [CharacterModel]()
    private var privComicList = [ComicModel]()
    private var delay = true
    private var privCurrentCharacter: CharacterModel

    // we need a delay to test the loadingCell, with its own delay on the test
    private let delaySeconds = 4
    static let characterPageSize = 20
    static let comicPageSize = 20

    init(delay: Bool) {
        self.delay = delay
        privCurrentCharacter = CharacterModel(id: 0, name: "", thumbnail: ThumbnailModel(path: "", ext: ""), description: "")
    }

    private func createCharacter(id: Int) -> CharacterModel {
        let thumbnail = ThumbnailModel(path: "http://i.annihil.us/u/prod/marvel/i/mg/3/50/526548a343e4b", ext: "jpg")
        return CharacterModel(id: id,
                              name: "Spiderman\(id)",
                              thumbnail: thumbnail,
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
    
    func getCharacters(page: Int, complete: @escaping (ServiceResult<[CharacterModel]?>) -> Void) {
        if page == 0 {
            privCharacterList.removeAll()
            createCharacterPage(from: 0, pageSize: MockCharacterViewModel.characterPageSize)
        } else if page == 1 {
            createCharacterPage(from: MockCharacterViewModel.characterPageSize, pageSize: MockCharacterViewModel.characterPageSize)
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
        complete: @escaping ( ServiceResult<[ComicModel]?> ) -> Void ) {
        if page == 0 {
            privComicList.removeAll()
            createComicPage(from: 0, pageSize: MockCharacterViewModel.comicPageSize)
        } else if page == 1 {
            createComicPage(from: MockCharacterViewModel.comicPageSize, pageSize: MockCharacterViewModel.comicPageSize)
        }
        if delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delaySeconds), execute: {
                return complete(.Success(self.privComicList, 0))
            })
        } else {
            return complete(.Success(self.privComicList, 0))
        }
    }

    private func createComic(id: Int) -> ComicModel {
        let thumbnail = ThumbnailModel(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/60/58dbce634ea70", ext: "jpg")
        return ComicModel(id: id,
                          title: "Title \(id)",
                          thumbnail: thumbnail)
    }
    
    private func createComicPage(from: Int, pageSize: Int) {
        let range = from..<from+pageSize
        range.forEach({ (id) in
            self.privComicList.append(createComic(id: id))
        })
    }
    



}