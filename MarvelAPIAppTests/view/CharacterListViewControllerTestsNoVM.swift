//
//  CharacterListVCTestsNoVM.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 04/07/2018.
//

import XCTest

@testable import MarvelAPIApp

class CharacterListViewControllerTestsNoVM: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterListViewController: CharacterListViewController!
    
    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterListViewController = storyboard.instantiateViewController(withIdentifier: "characterListViewController") as! CharacterListViewController
        rootWindow.rootViewController = characterListViewController
        _ = characterListViewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testLoadPages() {
        XCTAssert(characterListViewController.isFirstLoading)
        XCTAssertEqual(characterListViewController.collectionView.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(characterListViewController.page, 0)
    }
    
}
