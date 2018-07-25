//
//  CharacterViewControllerTestsDelay.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 05/07/2018.
//

import XCTest

@testable import MarvelAPIApp
@testable import Kingfisher

class CharacterViewControllerTestsDelay: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterViewController: CharacterViewController!
    private var mockCharacterViewModel: CharacterViewModelProtocol!
    let spiderManId = 1009610
    
    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterViewController = storyboard.instantiateViewController(withIdentifier: "characterViewController") as! CharacterViewController
        mockCharacterViewModel = MockCharacterViewModel(delay: true)
        // TODO
        let spiderMan = CharacterModel(id: spiderManId, name: "SpiderMan", thumbnail: ThumbnailModel(path: "", ext: ""), description: "")
        mockCharacterViewModel.currentCharacter = spiderMan
        characterViewController.characterViewModel = mockCharacterViewModel
        rootWindow.rootViewController = characterViewController
        _ = characterViewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testLoadData() {
        XCTAssert(characterViewController.isFirstLoading)
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 1), 0)
        XCTAssertEqual(characterViewController.page, 0)
    }

// TODO: test after implementing loadingCell for comics
//    func testSection1Cell0() {
//        let promise = expectation(description: "testSection1Cell0")
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) { [weak self] in
//            let indexPath = IndexPath(row: 0, section: 1)
//            let cell = self?.characterViewController.collectionView.cellForItem(at: indexPath)
//            XCTAssertEqual(cell?.reuseIdentifier, "comicCell")
//            promise.fulfill()
//        }
//        waitForExpectations(timeout: 8)
//    }
    
}
