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
    private var mockCharacterVM: CharacterVMProtocol!
    let spiderManId = 1009610

    override func setUp() {
        super.setUp()
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        characterVC = storyboard.instantiateViewController(withIdentifier: "characterVC") as! CharacterVC
        mockCharacterVM = MockCharacterVM(delay: false)
        let spiderMan = CharacterModel(id: spiderManId, name: "SpiderMan", imageURI: nil, description: "")
        mockCharacterVM.currentCharacter = spiderMan
        characterVC.characterVM = mockCharacterVM
        rootWindow.rootViewController = characterVC
        _ = characterVC.view
    }
    
    override func tearDown() {
        super.tearDown()
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
    
    func testCollectionView() {
        XCTAssertNotNil(characterVC.collectionView)
        XCTAssertNotNil(characterVC.collectionView.delegate)
        XCTAssertNotNil(characterVC.collectionView.dataSource)
        XCTAssertTrue(characterVC.conforms(to: UICollectionViewDelegate.self))
        XCTAssertTrue(characterVC.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(characterVC.responds(to: #selector(characterVC!.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(characterVC.responds(to: #selector(characterVC!.collectionView(_:cellForItemAt:))))
    }
    
    func testLoadPages() {
        let pageSizeDouble = MockCharacterVM.comicPageSize * 2
        XCTAssertFalse(characterVC.isFirstLoading)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 1), MockCharacterVM.comicPageSize)
        XCTAssertEqual(characterVC.page, 0)
        characterVC.loadNextPage()
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 1), pageSizeDouble)
        XCTAssertEqual(characterVC.page, 1)
        XCTAssertFalse(characterVC.noFurtherData)
        characterVC.loadNextPage()
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 1), pageSizeDouble)
        XCTAssertEqual(characterVC.page, 2)
        XCTAssert(characterVC.noFurtherData)
        characterVC.loadNextPage()
        XCTAssertEqual(characterVC.collectionView.numberOfItems(inSection: 1), pageSizeDouble)
        XCTAssertEqual(characterVC.page, 2)
        XCTAssert(characterVC.noFurtherData)
    }
    
    func testSection0() {
        let promise = expectation(description: "testSection0")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            let character = self?.characterVC.characterVM?.currentCharacter
            
            let characterCell = self?.characterVC.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CharacterCell
            XCTAssertEqual(characterCell?.reuseIdentifier, "characterCell")
            XCTAssertEqual(characterCell?.nameLabel.text, character?.name)

            let descriptionCell = self?.characterVC.collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? DescriptionCell
            XCTAssertEqual(descriptionCell?.reuseIdentifier, "descriptionCell")
            XCTAssertEqual(descriptionCell?.descriptionLabel.text, character?.description)

            let comicsTitleCell = self?.characterVC.collectionView.cellForItem(at: IndexPath(row: 2, section: 0)) as? ComicsTitleCell
            XCTAssertEqual(comicsTitleCell?.reuseIdentifier, "comicsTitleCell")
            XCTAssertEqual(comicsTitleCell?.comicsLabel.text, "comics")

            promise.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    func testSection1Cell0() {
        let promise = expectation(description: "testSection1Cell0")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            let indexPath = IndexPath(row: 0, section: 1)
            let cell = self?.characterVC.collectionView.cellForItem(at: indexPath) as? ComicCell
            let comic = self?.characterVC.characterVM?.comicList[0]
            XCTAssertEqual(cell?.titleLabel.text, comic?.title)
            //XCTAssertEqual(comic?.imageURI, "http://i.annihil.us/u/prod/marvel/i/mg/c/60/58dbce634ea70.jpg")
            promise.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    // TODO: fix issue with delay to test imageURI
    func testSectionCell19() {
        let lastRow = MockCharacterVM.comicPageSize - 1
        let promise = expectation(description: "testSection1Cell0")
        characterVC.collectionView.scrollToItem(at: IndexPath.init(row: lastRow, section: 1), at: UICollectionViewScrollPosition.bottom, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) { [weak self] in
            let indexPath = IndexPath(row: lastRow, section: 1)
            let cell = self?.characterVC.collectionView.cellForItem(at: indexPath) as? ComicCell
            let comic = self?.characterVC.characterVM?.comicList[lastRow]
            XCTAssertEqual(cell?.titleLabel.text, comic?.title)
            //XCTAssertEqual(comic?.imageURI, "http://i.annihil.us/u/prod/marvel/i/mg/c/60/58dbce634ea70.jpg")
            promise.fulfill()
        }
        waitForExpectations(timeout: 6)
    }
    
    func testScrollToBottom() {
        let lastRow = MockCharacterVM.comicPageSize - 1
        XCTAssertEqual(self.characterVC.page, 0)
        characterVC.collectionView.scrollToItem(at: IndexPath.init(row: lastRow, section: 1), at: UICollectionViewScrollPosition.bottom, animated: false)
        XCTAssertEqual(self.characterVC.page, 1)
    }

}
