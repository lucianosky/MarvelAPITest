//
//  CharacterVCTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 29/06/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterVCTests: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterVC: CharacterVC!
    private var mockCharacterVM: CharacterVMProtocol!
    let spiderManId = 1009610

    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterVC = storyboard.instantiateViewController(withIdentifier: "characterVC") as! CharacterVC
        mockCharacterVM = MockCharacterVM(delay: false)
        let spiderMan = CharacterModel(id: spiderManId, name: "SpiderMan", imageURI: nil, description: "")
        mockCharacterVM.currentCharacter = spiderMan
        characterVC.characterVM = mockCharacterVM
        rootWindow.rootViewController = characterVC
        _ = characterVC.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    /////////////////
    
    func testLoadPages() {
        let pageSizeDouble = MockCharacterVM.pageSize * 2
        XCTAssertFalse(characterVC.isFirstLoading)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), MockCharacterVM.pageSize)
        XCTAssertEqual(characterVC.page, 0)
        characterVC.loadNextPage()
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterVC.page, 1)
        XCTAssertFalse(characterVC.noFurtherData)
        characterVC.loadNextPage()
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterVC.page, 2)
        XCTAssert(characterVC.noFurtherData)
        characterVC.loadNextPage()
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterVC.page, 2)
        XCTAssert(characterVC.noFurtherData)
    }
    
}
