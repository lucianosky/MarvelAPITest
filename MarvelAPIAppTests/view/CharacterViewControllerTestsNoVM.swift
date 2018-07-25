//
//  CharacterViewControllerTestsNoVM.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 05/07/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterViewControllerTestsNoVM: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterViewController: CharacterViewController!
    
    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterViewController = storyboard.instantiateViewController(withIdentifier: "characterViewController") as! CharacterViewController
        rootWindow.rootViewController = characterViewController
        _ = characterViewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testLoadPages() {
        XCTAssert(characterViewController.isFirstLoading)
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 1), 0)
        XCTAssertEqual(characterViewController.page, 0)
    }
    
}
