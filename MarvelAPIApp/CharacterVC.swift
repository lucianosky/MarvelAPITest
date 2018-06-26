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
    @IBOutlet weak var titleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = UIColor.black.cgColor
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
    
    func fromString(string: String, lineHeightMultiple: CGFloat) -> NSAttributedString {
        // https://medium.com/@deepdeviant/simple-way-to-change-uilabel-line-height-swift-4d0a0177beb
        // https://stackoverflow.com/questions/30845705/uitextview-lineheightmultiple-clips-top-first-line-of-text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.baselineOffset: -1], range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCell
//        cell.nameLabel.text = "Spider Man spinoff from 2012 movie"
        let characterModel = NetworkService.shared.characterList[indexPath.row]
        
        //cell.nameLabel.text = characterModel.name
        cell.nameLabel.attributedText = fromString(string: characterModel.name, lineHeightMultiple: 0.7)
        
        cell.squareView.layer.borderWidth = 1
        cell.squareView.layer.borderColor = UIColor.black.cgColor
        cell.nameView.layer.borderWidth = 1
        cell.nameView.layer.borderColor = UIColor.black.cgColor
        cell.nameView.backgroundColor = .comicPink
        if let uri = characterModel.imageURI {
            let url = URL(string: uri)
            cell.characterImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("size")
        let w = (UIScreen.main.bounds.width - (34.0 * 2.0) - 10.0) / 2.0
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
    
}
