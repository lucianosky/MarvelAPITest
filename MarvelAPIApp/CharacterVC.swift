//
//  CharacterVC.swift
//  MarvelAPIApp
//
//  Created by SoftDesign on 26/06/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.collectionView.register(CharacterVC.self, forCellWithReuseIdentifier: "CharacterHeader")
        NetworkService.shared.characters { (list) in
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NetworkService.shared.characterList.count
//        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCell
        let characterModel = NetworkService.shared.characterList[indexPath.row]
        // "Spider Man spinoff from 2012 movie"
        cell.nameLabel.attributedText = NSAttributedString.fromString(string: characterModel.name, lineHeightMultiple: 0.7)
        cell.squareView.layer.borderWidth = 1
        cell.squareView.layer.borderColor = UIColor.black.cgColor
        cell.nameView.layer.borderWidth = 1
        cell.nameView.layer.borderColor = UIColor.black.cgColor
        

        let remanderBy4 = indexPath.row % 4
        cell.nameView.backgroundColor = remanderBy4 == 1 || remanderBy4 == 2 ? .comicPink : .comicBlue
        
        if let uri = characterModel.imageURI {
            let url = URL(string: uri)
            cell.characterImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "characterHeader", for: indexPath) as! CharacterHeader
            header.rectangleView.backgroundColor = .comicYellow
            header.rectangleView.layer.borderWidth = 1
            header.rectangleView.layer.borderColor = UIColor.black.cgColor
            return header
            
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "characterFooter", for: indexPath)
            return footer
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        let w = 200 // UIScreen.main.bounds.width - (24.0 * 2.0) - 40.0
        return CGSize(width: w, height: 32)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let w = 200 // UIScreen.main.bounds.width - (24.0 * 2.0) - 40.0
        return CGSize(width: w, height: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (UIScreen.main.bounds.width - (24.0 * 2.0) - 30.0) / 2.0
        return CGSize(width: w, height: w)
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
