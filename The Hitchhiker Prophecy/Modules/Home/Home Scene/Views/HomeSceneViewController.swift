//
//  HomeSceneViewController.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

class HomeSceneViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var characterCollectionView: UICollectionView!
    
    var interactor: HomeSceneBusinessLogic?
    var router: HomeSceneRoutingLogic?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        interactor?.fetchCharacters()
        
    }
}


extension HomeSceneViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell.init()
    }
    
}


extension HomeSceneViewController: HomeSceneDisplayView {
    
    func didFetchCharacters(viewModel: [HomeScene.Search.ViewModel]) {
        // TODO: Implement
    }
    
    func failedToFetchCharacters(error: Error) {
        // TODO: Implement
    }
}
