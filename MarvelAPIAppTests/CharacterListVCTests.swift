//
//  CharacterListVCTests.swift
//  MarvelAPIAppTests
//
//  Created by SoftDesign on 29/06/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import XCTest

@testable import MarvelAPIApp

class CharacterListVCTests: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterListVC: CharacterListVC!
    
    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        rootWindow.rootViewController = characterListVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterListVC = storyboard.instantiateInitialViewController() as! CharacterListVC
        _ = characterListVC.view
        characterListVC.viewWillAppear(false)
        characterListVC.viewDidAppear(false)
    }
    
    override func tearDown() {
        super.tearDown()
        characterListVC.viewWillDisappear(false)
        characterListVC.viewDidDisappear(false)
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testLoadData() {
        XCTAssert(characterListVC.isFirstLoading)
        XCTAssertEqual(characterListVC.collectionView.numberOfItems(inSection: 0), 1)
        let promise = expectation(description: "...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            XCTAssertEqual(self?.characterListVC.collectionView.numberOfItems(inSection: 0), 20)
            promise.fulfill()
        }
        waitForExpectations(timeout: 12)
    }
    
}
