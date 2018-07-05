//
//  CharacterVCTestsNoVM.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 05/07/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterVCTestsNoVM: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterVC: CharacterVC!
    
    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterVC = storyboard.instantiateViewController(withIdentifier: "characterVC") as! CharacterVC
        rootWindow.rootViewController = characterVC
        _ = characterVC.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testLoadPages() {
        XCTAssert(characterVC.isFirstLoading)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 1), 0)
        XCTAssertEqual(characterVC.page, 0)
    }
    
}
