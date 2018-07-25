//
//  CharacterListVCTestsDelay.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 29/06/2018.
//

import XCTest

@testable import MarvelAPIApp
@testable import Kingfisher

class CharacterListViewControllerTestsDelay: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterListViewController: CharacterListViewController!
    private var mockCharacterVM: CharacterVMProtocol!


    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterListViewController = storyboard.instantiateViewController(withIdentifier: "characterListViewController") as! CharacterListViewController
        mockCharacterVM = MockCharacterVM(delay: true)
        characterListViewController.characterVM = mockCharacterVM
        rootWindow.rootViewController = characterListViewController
        _ = characterListViewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testLoadData() {
        XCTAssert(characterListViewController.isFirstLoading)
        XCTAssertEqual(characterListViewController.collectionView.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(characterListViewController.page, 0)
    }
    
    func testCell0() {
        let promise = expectation(description: "testCell0")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self?.characterListViewController.collectionView.cellForItem(at: indexPath)
            XCTAssertEqual(cell?.reuseIdentifier, "loadingCell")
            promise.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
}
