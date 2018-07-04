//
//  CharacterVMProtocol.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 03/07/2018.
//

// import Foundation

protocol CharacterVMProtocol {
    
    func getCharacterList() -> [CharacterModel]
    
    func getCharacters(
        page: Int,
        complete: @escaping ( Result<[CharacterModel]?> ) -> Void )
    
}
