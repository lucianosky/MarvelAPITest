//
//  CharacterListViewController.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 26/06/2018.
//

import UIKit
import Kingfisher

class CharacterListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageView: UIView!
    
    var characterViewModel: CharacterViewModelProtocol?
    
    private var _isFirstLoading = true
    private var _noFurtherData = false
    private var _page = -1

    // used on tests (read only)
    var isFirstLoading: Bool { get { return _isFirstLoading } }
    var noFurtherData: Bool { get { return _noFurtherData } }
    var page: Int { get { return _page } }

    private var isPullingUp = false
    private var loadingData = false
    private let preloadCount = 10
    private var screenWidth: CGFloat = 0
    private var characterCellSize: CGFloat = 0
    private var loadingCellSize: CGFloat = 0
    private var currentCharacter: CharacterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.setBlackBorder()
        computeSizes()
        loadNextPage()
    }
    
    private func computeSizes() {
        screenWidth = UIScreen.main.bounds.width
        
        // 2 * 10.0 = 20.0 --> external border
        // 2 * 10.0 = 20.0 --> internal border
        //     10.0 = 10.0 --> border between 2 cells
        // sum      = 50.0
        // divide by 2.0, since there are 2 columns
        characterCellSize = (screenWidth - 50.0) / 2.0
        
        // 2 * 10.0 = 20.0 --> external border
        // 2 * 10.0 = 20.0 --> internal border
        // sum      = 40.0
        loadingCellSize = screenWidth - 40.0
    }
    
    func loadNextPage() {
        if loadingData || _noFurtherData {
            return
        }
        _page += 1
        loadingData = true
        let previousCount = characterViewModel?.characterList.count ?? 0
        characterViewModel?.getCharacters(page: _page) { [weak self] (result) in
            self?._isFirstLoading = false
            self?.isPullingUp = false
            self?.loadingData = false
            switch result {
            case .Success(_, _):
                self?.collectionView.reloadData()
                let count = self?.characterViewModel?.characterList.count ?? 0
                if count == previousCount {
                    self?._noFurtherData = true
                }
            case .Error(let message, let statusCode):
                print("Error \(message) \(statusCode ?? 0)")
            }
        }
    }

    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _isFirstLoading ? 1 : (characterViewModel?.characterList.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if _isFirstLoading {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath)
        }
        if (indexPath.row >= (characterViewModel?.characterList.count ?? 0) - preloadCount) && !loadingData {
            loadNextPage()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterListCell", for: indexPath) as! CharacterListCell
        let characterModel = characterViewModel!.characterList[indexPath.row]
        cell.nameLabel.attributedText = NSAttributedString.fromString(string: characterModel.name, lineHeightMultiple: 0.7)
        cell.squareView.setBlackBorder()
        cell.nameView.setBlackBorder()
        // this will create a diagonal grid with pink/blue background colors for character names
        let remanderBy4 = indexPath.row % 4
        cell.nameView.backgroundColor = remanderBy4 == 1 || remanderBy4 == 2 ? .comicPink : .comicBlue
        let url = URL(string: characterModel.thumbnail.fullName)
        cell.characterImageView.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "characterListHeader", for: indexPath) as! CharacterListHeader
            header.rectangleView.backgroundColor = .comicYellow
            header.rectangleView.setBlackBorder()
            return header
            
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "characterListFooter", for: indexPath)
            return footer
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !_isFirstLoading {
            if let character = characterViewModel?.characterList[indexPath.row] {
                characterViewModel?.currentCharacter = character
                self.performSegue(withIdentifier: "segueToCharacter", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCharacter" {
            if let characterViewController = segue.destination as? CharacterViewController {
                characterViewController.characterViewModel = characterViewModel
            }
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = _isFirstLoading ? loadingCellSize : characterCellSize
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: loadingCellSize, height: 32)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: loadingCellSize, height: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    // MARK: - scrollView protocols
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isPullingUp {
            return
        }
        let scrollThreshold:CGFloat = 30
        let scrollDelta = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height
        if  scrollDelta > scrollThreshold {
            isPullingUp = true
            loadNextPage()
        }
    }
    
}
