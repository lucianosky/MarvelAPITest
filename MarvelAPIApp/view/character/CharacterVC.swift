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
    
    var screenWidth: CGFloat = 0
    var characterCellSize: CGFloat = 0
    var delegate: CharacterListProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.setBlackBorder()
        computeSizes()
        
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
//        }
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
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let characterModel = delegate?.getCurrentCharacter() else {
            print("error reading characterModel")
            // TO DO: (this should never happen) - improve error treatment
            return comicsTitleCell(withString: "error", at: indexPath)
        }
        switch indexPath.row {
        case 0: return characterCell(forCharacterModel: characterModel, at: indexPath)
        case 1: return descriptionCell(forCharacterModel: characterModel, at: indexPath)
        default: return comicsTitleCell(withString: "comics", at: indexPath)
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

}
