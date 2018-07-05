//
//  CharacterVMProtocol.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 03/07/2018.
//

// import Foundation

protocol CharacterVMProtocol {
    
    func getCharacters(
        page: Int,
        complete: @escaping ( Result<[CharacterModel]?> ) -> Void )
    
    var characterList: [CharacterModel] { get }
    
    var currentCharacter: CharacterModel { get set }

    func getCharacterComics(
        page: Int,
        character: Int,
        complete: @escaping ( Result<[ComicModel]?> ) -> Void )

    var comicList: [ComicModel] { get }
    
}
