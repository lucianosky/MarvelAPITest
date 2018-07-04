//
//  CharacterListVCTestsNoVM.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 04/07/2018.
//

import XCTest

@testable import MarvelAPIApp
@testable import Kingfisher

class CharacterListVCTestsNoVM: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterListVC: CharacterListVC!
    
    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterListVC = storyboard.instantiateViewController(withIdentifier: "characterListVC") as! CharacterListVC
        rootWindow.rootViewController = characterListVC
        _ = characterListVC.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testLoadPages() {
        XCTAssert(characterListVC.isFirstLoading)
        XCTAssertEqual(characterListVC.collectionView.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(characterListVC.page, 0)
    }
    
}
