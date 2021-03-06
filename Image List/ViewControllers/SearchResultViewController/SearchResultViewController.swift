//
//  SearchResultViewController.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import UIKit

protocol SearchResultViewControllerDelegate: class {
    func openFullScreenWith(searchResults: [SearchResult], itemToOpenIntially: Int)
}

class SearchResultViewController: UIViewController {
    
    // MARK: - Properties
    var searchResults = [SearchResult]()
    var searchInteractor: SearchInteractor?
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
// MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCellNibWithCollectionView()
        setupCollectionView()
    }
    
    // MARK: - Methods
    private  func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerCellNibWithCollectionView() {
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
    }
    
    func updateResults(results: [SearchResult]) {
        searchResults = results
        collectionView.reloadData()
    }
    
    fileprivate func reachedAtLastCell() {
        guard searchResults.count != 0, searchInteractor?.canFetchNextPage(currentDataSize: searchResults.count) == true else {
            return
        }
        
        fetchNextPage()
    }
    
    fileprivate func fetchNextPage() {
        searchInteractor?.fetchNextPage(completion: { [weak self] (results, errorMessage) in
            guard errorMessage == nil else {
                return
            }
            
            self?.searchResults.append(contentsOf: results)
            self?.collectionView.reloadData()
        })
    }

}

// MARK: - UICollectionView DataSource & UICollectionView Delegate
extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        let result = searchResults[indexPath.item]
        cell.setImageWith(url: result.thumbnailURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimention = collectionView.bounds.width/2 - 5
        return CGSize(width: dimention, height: dimention)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == searchResults.count - 1 {
            reachedAtLastCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.openFullScreenWith(searchResults: searchResults, itemToOpenIntially: indexPath.item)
    }
}
