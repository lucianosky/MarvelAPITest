//
//  CharacterListVCTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 29/06/2018.
//

import XCTest

@testable import MarvelAPIApp
@testable import Kingfisher

class CharacterListVCTestsDelay: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterListVC: CharacterListVC!
    private var mockCharacterVM: CharacterVMProtocol!


    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterListVC = storyboard.instantiateViewController(withIdentifier: "characterListVC") as! CharacterListVC
        mockCharacterVM = MockCharacterVM(delay: true)
        characterListVC.characterVM = mockCharacterVM
        rootWindow.rootViewController = characterListVC
        _ = characterListVC.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testLoadData() {
        XCTAssert(characterListVC.isFirstLoading)
        XCTAssertEqual(characterListVC.collectionView.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(characterListVC.page, 0)
    }
    
    func testCell0() {
        let promise = expectation(description: "testCell")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self?.characterListVC.collectionView.cellForItem(at: indexPath)
            XCTAssertEqual(cell?.reuseIdentifier, "loadingCell")
            promise.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
}
