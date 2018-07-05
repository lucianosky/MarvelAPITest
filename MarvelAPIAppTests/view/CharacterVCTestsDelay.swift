//
//  CharacterVCTestsDelay.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 05/07/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterVCTestsDelay: XCTestCase {
    
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
        mockCharacterVM = MockCharacterVM(delay: true)
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
    
    func testLoadData() {
        XCTAssert(characterVC.isFirstLoading)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 1), 0)
        XCTAssertEqual(characterVC.page, 0)
    }
    
//    func testSection1Cell0() {
//        let promise = expectation(description: "testSection1Cell0")
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
//            let indexPath = IndexPath(row: 0, section: 1)
//            let cell = self?.characterVC.collectionView.cellForItem(at: indexPath)
//            XCTAssertEqual(cell?.reuseIdentifier, "loadingCell")
//            promise.fulfill()
//        }
//        waitForExpectations(timeout: 4)
//    }
    
}
