//
//  CharacterViewControllerTests.swift
//  MarvelAPIAppTests
//
//  Created by Luciano Sclovsky on 29/06/2018.
//

import XCTest

@testable import MarvelAPIApp
@testable import Kingfisher

class CharacterViewControllerTests: XCTestCase {
    
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
        mockCharacterViewModel = MockCharacterViewModel(delay: false)
        // TODO
        let thumbnail = ThumbnailModel(path: "", ext: "")
        let spiderMan = CharacterModel(id: spiderManId, name: "SpiderMan", thumbnail: thumbnail, description: "")
        mockCharacterViewModel.currentCharacter = spiderMan
        characterViewController.characterViewModel = mockCharacterViewModel
        rootWindow.rootViewController = characterViewController
        _ = characterViewController.view
    }
    
    override func tearDown() {
        super.tearDown()
        characterViewController = nil
        mockCharacterViewModel = nil
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        rootWindow = nil
    }
    
    func testCollectionView() {
        XCTAssertNotNil(characterViewController.collectionView)
        XCTAssertNotNil(characterViewController.collectionView.delegate)
        XCTAssertNotNil(characterViewController.collectionView.dataSource)
        XCTAssertTrue(characterViewController.conforms(to: UICollectionViewDelegate.self))
        XCTAssertTrue(characterViewController.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(characterViewController.responds(to: #selector(characterViewController!.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(characterViewController.responds(to: #selector(characterViewController!.collectionView(_:cellForItemAt:))))
    }
    
    func testLoadPages() {
        let pageSizeDouble = MockCharacterViewModel.comicPageSize * 2
        XCTAssertFalse(characterViewController.isFirstLoading)
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 1), MockCharacterViewModel.comicPageSize)
        XCTAssertEqual(characterViewController.page, 0)
        characterViewController.loadNextPage()
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 1), pageSizeDouble)
        XCTAssertEqual(characterViewController.page, 1)
        XCTAssertFalse(characterViewController.noFurtherData)
        characterViewController.loadNextPage()
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 1), pageSizeDouble)
        XCTAssertEqual(characterViewController.page, 2)
        XCTAssert(characterViewController.noFurtherData)
        characterViewController.loadNextPage()
        XCTAssertEqual(characterViewController.collectionView.numberOfItems(inSection: 1), pageSizeDouble)
        XCTAssertEqual(characterViewController.page, 2)
        XCTAssert(characterViewController.noFurtherData)
    }
    
    func testSection0() {
        let promise = expectation(description: "testSection0")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            let character = self?.characterViewController.characterViewModel?.currentCharacter
            
            let characterCell = self?.characterViewController.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CharacterCell
            XCTAssertEqual(characterCell?.reuseIdentifier, "characterCell")
            XCTAssertEqual(characterCell?.nameLabel.text, character?.name)

            let descriptionCell = self?.characterViewController.collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? DescriptionCell
            XCTAssertEqual(descriptionCell?.reuseIdentifier, "descriptionCell")
            XCTAssertEqual(descriptionCell?.descriptionLabel.text, character?.description)

            let comicsTitleCell = self?.characterViewController.collectionView.cellForItem(at: IndexPath(row: 2, section: 0)) as? ComicsTitleCell
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
            let cell = self?.characterViewController.collectionView.cellForItem(at: indexPath) as? ComicCell
            let comic = self?.characterViewController.characterViewModel?.comicList[0]
            XCTAssertEqual(cell?.titleLabel.text, comic?.title)
            XCTAssertEqual(comic?.thumbnail.fullName, "http://i.annihil.us/u/prod/marvel/i/mg/c/60/58dbce634ea70.jpg")
            promise.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    // TODO: fix issue with delay to test imageURI
    func testSectionCell19() {
        let row = MockCharacterViewModel.comicPageSize / 2 - 1
        let promise = expectation(description: "testSectionCell19")
        characterViewController.collectionView.scrollToItem(at: IndexPath.init(row: row, section: 1), at: UICollectionViewScrollPosition.bottom, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) { [weak self] in
            let indexPath = IndexPath(row: row, section: 1)
            let cell = self?.characterViewController.collectionView.cellForItem(at: indexPath) as? ComicCell
            let comic = self?.characterViewController.characterViewModel?.comicList[row]
            XCTAssertEqual(cell?.titleLabel.text, comic?.title)
            XCTAssertEqual(comic?.thumbnail.fullName, "http://i.annihil.us/u/prod/marvel/i/mg/c/60/58dbce634ea70.jpg")
            promise.fulfill()
        }
        waitForExpectations(timeout: 12)
    }
    
    func testScrollToBottom() {
        let lastRow = MockCharacterViewModel.comicPageSize - 1
        XCTAssertEqual(self.characterViewController.page, 0)
        characterViewController.collectionView.scrollToItem(at: IndexPath.init(row: lastRow, section: 1), at: UICollectionViewScrollPosition.bottom, animated: false)
        XCTAssertEqual(self.characterViewController.page, 1)
    }

}