//
//  CharacterListVCTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 04/07/2018.
//

import XCTest

@testable import MarvelAPIApp
@testable import Kingfisher

class CharacterListViewControllerTests: XCTestCase {
    
    private var rootWindow: UIWindow!
    private var characterListViewController: CharacterListViewController!
    private var mockCharacterVM: CharacterVMProtocol!
    
    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterListViewController = storyboard.instantiateViewController(withIdentifier: "characterListViewController") as! CharacterListViewController
        mockCharacterVM = MockCharacterVM(delay: false)
        characterListViewController.characterVM = mockCharacterVM
        rootWindow.rootViewController = characterListViewController
        _ = characterListViewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        characterListViewController = nil
        mockCharacterVM = nil
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        rootWindow = nil
    }
    
    func testCollectionView() {
        XCTAssertNotNil(characterListViewController.collectionView)
        XCTAssertNotNil(characterListViewController.collectionView.delegate)
        XCTAssertNotNil(characterListViewController.collectionView.dataSource)
        XCTAssertTrue(characterListViewController.conforms(to: UICollectionViewDelegate.self))
        XCTAssertTrue(characterListViewController.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(characterListViewController.responds(to: #selector(characterListViewController!.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(characterListViewController.responds(to: #selector(characterListViewController!.collectionView(_:cellForItemAt:))))
        XCTAssertTrue(characterListViewController.responds(to: #selector(characterListViewController!.collectionView(_:didSelectItemAt:))))
    }
    
    func testLoadPages() {
        let pageSizeDouble = MockCharacterVM.characterPageSize * 2
        XCTAssertFalse(characterListViewController.isFirstLoading)
        XCTAssertEqual(characterListViewController.collectionView.numberOfItems(inSection: 0), MockCharacterVM.characterPageSize)
        XCTAssertEqual(characterListViewController.page, 0)
        characterListViewController.loadNextPage()
        XCTAssertEqual(characterListViewController.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterListViewController.page, 1)
        XCTAssertFalse(characterListViewController.noFurtherData)
        characterListViewController.loadNextPage()
        XCTAssertEqual(characterListViewController.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterListViewController.page, 2)
        XCTAssert(characterListViewController.noFurtherData)
        characterListViewController.loadNextPage()
        XCTAssertEqual(characterListViewController.collectionView.numberOfItems(inSection: 0), pageSizeDouble)
        XCTAssertEqual(characterListViewController.page, 2)
        XCTAssert(characterListViewController.noFurtherData)
    }

    func testCell0() {
        let promise = expectation(description: "testCell0")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self?.characterListViewController.collectionView.cellForItem(at: indexPath) as? CharacterListCell
            let character = self?.characterListViewController.characterVM?.characterList[0]
            XCTAssertEqual(cell?.nameLabel.text, character?.name)
            XCTAssertEqual(character?.thumbnail.fullName, "http://i.annihil.us/u/prod/marvel/i/mg/3/50/526548a343e4b.jpg")
            promise.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testCell19() {
        let row = MockCharacterVM.comicPageSize / 2 - 1
        let promise = expectation(description: "testCell19")
        characterListViewController.collectionView.scrollToItem(at: IndexPath.init(row: row, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) { [weak self] in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self?.characterListViewController.collectionView.cellForItem(at: indexPath) as? CharacterListCell
            let character = self?.characterListViewController.characterVM?.characterList[row]
            XCTAssertEqual(cell?.nameLabel.text, character?.name)
            XCTAssertEqual(character?.thumbnail.fullName, "http://i.annihil.us/u/prod/marvel/i/mg/3/50/526548a343e4b.jpg")
            promise.fulfill()
        }
        waitForExpectations(timeout: 8)
    }
    
    func testScrollToBottom() {
        let lastRow = MockCharacterVM.characterPageSize - 1
        XCTAssertEqual(self.characterListViewController.page, 0)
        characterListViewController.collectionView.scrollToItem(at: IndexPath.init(row: lastRow, section: 0), at: UICollectionViewScrollPosition.bottom, animated: false)
        XCTAssertEqual(self.characterListViewController.page, 1)
   }

    // TODO
    /*func testPullUp() {
        let promise = expectation(description: "testPullUp")
        XCTAssertFalse(characterListViewController.isPullingUp)
        let rect = CGRect(x: 0,
                          y: characterListViewController.collectionView.frame.size.height,
                          width: characterListViewController.collectionView.frame.width,
                          height: 500)
        characterListViewController.collectionView.scrollRectToVisible(rect, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            XCTAssertTrue(self?.characterListViewController.isPullingUp ?? false)
            promise.fulfill()
        }
        waitForExpectations(timeout: 4)
    }*/
    
     func testDidSelectRowAt() {
        self.characterListViewController.collectionView.delegate?.collectionView!(self.characterListViewController.collectionView, didSelectItemAt: IndexPath.init(row: 0, section: 0))
        XCTAssertTrue(self.rootWindow.rootViewController?.presentedViewController is CharacterVC)
    }
    
}
