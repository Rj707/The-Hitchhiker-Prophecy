//
//  HomeCharacterCollectionViewCell.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Tarek on 6/15/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

class HomeCharacterCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var characterNameLabel: UILabel!
    @IBOutlet private weak var characterImageView: UIImageView!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        characterImageView.layer.cornerRadius = 8
        characterImageView.clipsToBounds = true
        
    }
    
    // MARK: - Setup
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> HomeCharacterCollectionViewCell {
        
        let kHomeCollectionCell = "HomeCharacterCollectionViewCell"
        collectionView.register(UINib(nibName:"HomeCharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kHomeCollectionCell)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeCollectionCell, for: indexPath) as! HomeCharacterCollectionViewCell
        return cell
    }
    
    
    func configure(with viewModel: HomeScene.Search.ViewModel) {
        characterNameLabel.text = viewModel.name
        if let url = URL(string: viewModel.imageUrl) {
            characterImageView.af_setImage(withURL: url,
                                           placeholderImage: UIImage(named: "placeHolder"))
        } else {
            characterImageView.image = UIImage(named:"placeHolder")
        }
    }
}

