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

    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        rootWindow.rootViewController = characterVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterVC = storyboard.instantiateViewController(withIdentifier: "characterVC") as! CharacterVC
        _ = characterVC.view
        characterVC.viewDidLoad()
        characterVC.viewWillAppear(false)
        characterVC.viewDidAppear(false)
    }
    
    override func tearDown() {
        super.tearDown()
        characterVC.viewWillDisappear(false)
        characterVC.viewDidDisappear(false)
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testExample() {
        //characterVC.collectionView.reloadData()
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), 2)
    }
    
    
}
