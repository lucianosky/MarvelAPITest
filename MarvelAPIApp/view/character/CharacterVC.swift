//
//  CharacterVC.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 27/06/2018.
//

import UIKit
import Kingfisher

class CharacterVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var characterVM: CharacterVMProtocol?

    var isFirstLoading = true
    var isPullingUp = false
    var loadingData = false
    var noFurtherData = false
    var page = -1
    let preloadCount = 10
    var screenWidth: CGFloat = 0
    var coverWidth: CGFloat = 0
    var coverHeight: CGFloat = 0
    var characterCellSize: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.setBlackBorder()
        computeSizes()
        loadNextPage()
    }
    
    func loadNextPage() {
        if loadingData || noFurtherData {
            return
        }
        page += 1
        loadingData = true
        // TODO: create error treatment below (should never happen)
        let id = characterVM?.currentCharacter.id ?? 0
        let previousCount = characterVM?.comicList.count
        characterVM?.getCharacterComics(page: page, character: id){ [weak self] (result) in
            self?.isFirstLoading = false
            self?.isPullingUp = false
            self?.loadingData = false
            switch result {
            case .Success(_, _):
                self?.collectionView.reloadData()
                let count = self?.characterVM?.comicList.count ?? 0
                if count == previousCount {
                    self?.noFurtherData = true
                }
            case .Error(let message, let statusCode):
                print("Error \(message) \(statusCode ?? 0)")
            }
        }
    }
    
    @IBAction func backButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func computeSizes() {
        screenWidth = UIScreen.main.bounds.width
        
        // 2 * 10.0 = 20.0 --> external border
        // 2 * 10.0 = 20.0 --> internal border
        // sum      = 40.0
        characterCellSize = screenWidth - 40.0
        
        
        // 2 * 10.0 = 20.0 --> external border
        // 2 * 10.0 = 20.0 --> internal border
        //     10.0 = 10.0 --> border between 2 cells
        // sum      = 50.0
        // divide by 2.0, since there are 2 columns
        coverWidth = (screenWidth - 50.0) / 2.0
        
        // keep a proportion, cover is portrait (height larger then width)
        coverHeight = coverWidth * 1.86

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return isFirstLoading ? 0 : (characterVM?.comicList.count ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let characterModel = characterVM?.currentCharacter else {
                print("error reading characterModel")
                // TO DO: (this should never happen) - improve error treatment
                return comicsTitleCell(withString: "error", at: indexPath)
            }
            switch indexPath.row {
            case 0: return characterCell(forCharacterModel: characterModel, at: indexPath)
            case 1: return descriptionCell(forCharacterModel: characterModel, at: indexPath)
            default: return comicsTitleCell(withString: "comics", at: indexPath)
            }
        } else {
            let count = characterVM?.comicList.count ?? 0
            if (indexPath.row >= count - preloadCount) && !loadingData {
                loadNextPage()
            }
            let comicModel = characterVM?.comicList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCell
            cell.titleLabel.text = comicModel?.title ?? ""
            cell.squareView.setBlackBorder()
            cell.titleView.setBlackBorder()
            cell.titleView.backgroundColor = .white
            if let uri = comicModel?.imageURI {
                let url = URL(string: uri)
                cell.coverImageView.kf.setImage(with: url)
            }
            return cell
        }
    }
    
    private func characterCell(forCharacterModel characterModel: CharacterModel, at indexPath: IndexPath) -> CharacterCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCell
        cell.nameLabel.attributedText = NSAttributedString.fromString(string: characterModel.name, lineHeightMultiple: 0.7)
        cell.squareView.setBlackBorder()
        cell.nameView.setBlackBorder()
        cell.nameView.backgroundColor = .comicYellow
        if let uri = characterModel.imageURI {
            let url = URL(string: uri)
            cell.characterImageView.kf.setImage(with: url)
        }
        return cell
    }

    private func descriptionCell(forCharacterModel characterModel: CharacterModel, at indexPath: IndexPath) -> DescriptionCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "descriptionCell", for: indexPath) as! DescriptionCell
        cell.squareView.setBlackBorder()
        cell.squareView.backgroundColor = .comicYellow
        cell.descriptionLabel.attributedText = NSAttributedString.fromString(string: characterModel.description, lineHeightMultiple: 0.7)
        return cell
    }
    
    private func comicsTitleCell(withString string: String, at indexPath: IndexPath) -> ComicsTitleCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicsTitleCell", for: indexPath) as! ComicsTitleCell
        cell.comicsLabel.attributedText = NSAttributedString.fromString(string: string, lineHeightMultiple: 0.7)
        cell.squareView.setBlackBorder()
        cell.squareView.backgroundColor = .comicYellow
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let size = characterCellSize
            let height: CGFloat
            switch indexPath.row {
            case 0:
                height = size
            case 1:
                height = 100
            default:
                height = 33
            }
            return CGSize(width: size, height: height)
        } else {
            return CGSize(width: coverWidth, height: coverHeight)
        }
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: characterCellSize, height: 10)
        }
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
