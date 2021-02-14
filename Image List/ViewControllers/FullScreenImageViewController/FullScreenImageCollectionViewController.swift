//
//  FullScreenImageCollectionViewController.swift
//  Image List
//
//  Created by Asim on 15/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import UIKit


class FullScreenImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var searchResults = [SearchResult]()
    
    var itemToOpenIntially = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCellNibWithCollectionView()
        
        self.collectionView.scrollToItem(at: IndexPath(item: itemToOpenIntially, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    private func registerCellNibWithCollectionView() {
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        let result = searchResults[indexPath.item]
        cell.setImageWith(previewURL: result.thumbnailURL, fullScreenURL: result.fullScreenURL)
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    
    
    // MARK: - Type Methods
    class func new(withSearchResults searchResults: [SearchResult], itemToOpenIntially: Int) -> FullScreenImageCollectionViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FullScreenImageCollectionViewController") as! FullScreenImageCollectionViewController
        vc.searchResults = searchResults
        vc.itemToOpenIntially = itemToOpenIntially
        return vc
    }

}
