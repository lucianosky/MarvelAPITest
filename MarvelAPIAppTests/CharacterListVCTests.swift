//
//  CharacterListVCTests2.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 04/07/2018.
//

import XCTest

@testable import MarvelAPIApp
@testable import Kingfisher

class CharacterListVCTests: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterListVC: CharacterListVC!
    private var mockCharacterVM: CharacterVMProtocol!
    
    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterListVC = storyboard.instantiateViewController(withIdentifier: "characterListVC") as! CharacterListVC
        mockCharacterVM = MockCharacterVM(delay: false)
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
    
    func testTable() {
        XCTAssertNotNil(characterListVC.collectionView)
        XCTAssertNotNil(characterListVC.collectionView.delegate)
        XCTAssertNotNil(characterListVC.collectionView.dataSource)
        XCTAssertTrue(characterListVC.conforms(to: UICollectionViewDelegate.self))
        XCTAssertTrue(characterListVC.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(characterListVC.responds(to: #selector(characterListVC!.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(characterListVC.responds(to: #selector(characterListVC!.collectionView(_:cellForItemAt:))))
        XCTAssertTrue(characterListVC.responds(to: #selector(characterListVC!.collectionView(_:didSelectItemAt:))))
    }
    
    func testLoadPages() {
        let pageSizeDouble = MockCharacterVM.pageSize * 2
        XCTAssertFalse(characterListVC.isFirstLoading)
        XCTAssertEqual(characterListVC.collectionView.numberOfItems(inSection: 0), MockCharacterVM.pageSize)
        XCTAssertEqual(characterListVC.page, 0)
        characterListVC.loadNextPage()
        XCTAssertEqual(characterListVC.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterListVC.page, 1)
        XCTAssertFalse(characterListVC.noFurtherData)
        characterListVC.loadNextPage()
        XCTAssertEqual(characterListVC.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterListVC.page, 2)
        XCTAssert(characterListVC.noFurtherData)
        characterListVC.loadNextPage()
        XCTAssertEqual(characterListVC.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterListVC.page, 2)
        XCTAssert(characterListVC.noFurtherData)
    }

    func testCell0() {
        let promise = expectation(description: "testCell")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self?.characterListVC.collectionView.cellForItem(at: indexPath) as? CharacterListCell
            let character = self?.characterListVC.characterVM?.getCharacterList()[0]
            XCTAssertEqual(cell?.nameLabel.text, character?.name)
            XCTAssertEqual(character?.imageURI, "http://i.annihil.us/u/prod/marvel/i/mg/3/50/526548a343e4b.jpg")
            promise.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testCell19() {
        let lastRow = MockCharacterVM.pageSize - 1
        let promise = expectation(description: "testCell")
        characterListVC.collectionView.scrollToItem(at: IndexPath.init(row: lastRow, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            let indexPath = IndexPath(row: lastRow, section: 0)
            let cell = self?.characterListVC.collectionView.cellForItem(at: indexPath) as? CharacterListCell
            let character = self?.characterListVC.characterVM?.getCharacterList()[lastRow]
            XCTAssertEqual(cell?.nameLabel.text, character?.name)
            XCTAssertEqual(character?.imageURI, "http://i.annihil.us/u/prod/marvel/i/mg/3/50/526548a343e4b.jpg")
            promise.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testScrollToBottom() {
        let lastRow = MockCharacterVM.pageSize - 1
        XCTAssertEqual(self.characterListVC.page, 0)
        characterListVC.collectionView.scrollToItem(at: IndexPath.init(row: lastRow, section: 0), at: UICollectionViewScrollPosition.bottom, animated: false)
        XCTAssertEqual(self.characterListVC.page, 1)
   }
    
     func testDidSelectRowAt() {
        self.characterListVC.collectionView.delegate?.collectionView!(self.characterListVC.collectionView, didSelectItemAt: IndexPath.init(row: 0, section: 0))
        XCTAssertTrue(self.rootWindow.rootViewController?.presentedViewController is CharacterVC)
    }
    
}
