//
//  CharacterViewModelProtocol.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 03/07/2018.
//

// import Foundation

protocol CharacterViewModelProtocol {
    
    func getCharacters(
        page: Int,
        complete: @escaping ( ServiceResult<[CharacterModel]?> ) -> Void )
    
    var characterList: [CharacterModel] { get }
    
    var currentCharacter: CharacterModel { get set }

    func getCharacterComics(
        page: Int,
        character: Int,
        complete: @escaping ( ServiceResult<[ComicModel]?> ) -> Void )

    var comicList: [ComicModel] { get }
    
}
