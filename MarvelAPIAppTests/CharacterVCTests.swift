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
    
    // TODO extend testing
    func testExample() {
        XCTAssert(characterVC.isFirstLoading)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 1), 0)
        // TODO: we need the delegate here
//        let promise = expectation(description: "loading data")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
//            XCTAssertEqual(self?.characterVC.collectionView.numberOfItems(inSection: 1), 20)
//            promise.fulfill()
//        }
//        waitForExpectations(timeout: 12)
    }
    
    
}
