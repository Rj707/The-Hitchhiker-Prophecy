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
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    var interactor: HomeSceneBusinessLogic?
    var router: HomeSceneRoutingLogic?
    
    var characters = [HomeScene.Search.ViewModel]()
    
    private var indexOfCellBeforeDragging = 0
    
    var  layout = HomeScene.LayoutType.list
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        self.characterCollectionView.register(UINib(nibName: "HomeCharacterCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeCharacterCollectionViewCell")
        
        interactor?.fetchCharacters()
        
        collectionViewLayout.minimumLineSpacing = 0
        
    }
    
    @IBAction func changeLayoutButtontouched(_ sender : UIButton)
    {
        self.characterCollectionView.alpha = 0
        
        if layout == .list
        {
            layout = .peek
            
            if let flowLayout = characterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = .horizontal
            }
        }
        else
        {
            layout = .list
            
            if let flowLayout = characterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = .vertical
            }
        }
        
        UIView.animate(withDuration: 1.0) {
            self.characterCollectionView.alpha = 1
        }
        characterCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayoutItemSize()
    }
    
    
    
}

extension HomeSceneViewController  {
    
    // =================================
    // MARK: - Layout Helpers:
    // =================================
    
    private func calculateSectionInset() -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)
        
        let buttonWidth: CGFloat = 50
        
        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return inset
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(characters.count - 1, index))
        return safeIndex
    }
}



extension HomeSceneViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = HomeCharacterCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        cell.configure(with: characters[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToCharacterDetailsWithCharacter(at: indexPath.row)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let leadingTrailing : CGFloat = 8
        let insetForSection : CGFloat = 16
        let ratio = 162.0/143.0
        
        let screenWidth = collectionView.frame.size.width
        
        if self.layout == .peek
        {
            let height = self.view.frame.size.height * (3/5)
            
            let width = screenWidth - insetForSection - 5 + leadingTrailing/2 - 16
            
            return CGSize(width: width, height: CGFloat(height))
        }
        
        let height = Double( (screenWidth/2) - insetForSection - 5) / ratio + 60
        
        let width = screenWidth - insetForSection - 5 + leadingTrailing/2
        
        return CGSize(width: width, height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if self.layout == .peek
        {
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16) //.zero
        }
        
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        if self.layout == .peek
        {
            return 2
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        if self.layout == .peek
        {
            return 8
        }
        return 2
    }
    
}

extension HomeSceneViewController : UIScrollViewDelegate
{
    // =================================
    // MARK: - UIScrollViewDelegate:
    // =================================
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if layout == .list {
            return
        }
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < characters.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension HomeSceneViewController: HomeSceneDisplayView {
    
    func didFetchCharacters(viewModel: [HomeScene.Search.ViewModel]) {
        
        // TODO: Implement
        self.characters = viewModel
        
        DispatchQueue.main.async {
            self.characterCollectionView.reloadData()
        }
    }
    
    func failedToFetchCharacters(error: Error) {
        
        // TODO: Implement
        
    }
}
