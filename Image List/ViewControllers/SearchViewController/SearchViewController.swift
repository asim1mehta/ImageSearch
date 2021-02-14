//
//  SearchImagesViewController.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import UIKit

//TODO: PAGINATION, FULL SCREEN, RECENT SEARCHES

class SearchViewController: UIViewController {

    // MARK: - Properties
    var recentSearches = [SearchQuery]()
    
    fileprivate let searchIntractor = SearchInteractor()
    
    var searchController: UISearchController? {
        return navigationItem.searchController
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
        
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSuggestionsTableView()
        setupSearchController()
        hideSuggestions()
    }
    
// MARK: - Methods
    
    func setupSuggestionsTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupSearchController() {
        let resultController = SearchResultViewController()
        resultController.searchInteractor = searchIntractor
        
        let searchController = UISearchController(searchResultsController: resultController)
        searchController.automaticallyShowsCancelButton = true
        searchController.showsSearchResultsController = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.searchTextField.placeholder = "Enter a keyword"
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func search(query: SearchQuery) {
        startAnimatingActivityIndicator()
        searchIntractor.performNewSearchFor(query: query) { [weak self] (results, errorMessage) in
            self?.stopAnimatingActivityIndicator()
            guard let weakSelf = self else {
                return
            }
            
            guard errorMessage == nil else {
                UIAlertController.show(title: "", message: errorMessage!, from: weakSelf)
                return
            }
            
            weakSelf.showResults(results)
        }
    }
    
    func showResults(_ results: [SearchResult]) {
        guard let searchResultController = searchController?.searchResultsController as? SearchResultViewController else {
            return
        }
        
        searchResultController.updateResults(results: results)
        
        searchController?.showsSearchResultsController = true
    }
    
    func startAnimatingActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func stopAnimatingActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}


// MARK: - UISearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = SearchQuery(keyword: searchBar.text!)
        search(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController?.showsSearchResultsController = false
        stopAnimatingActivityIndicator()
        searchIntractor.cancelLastSearch()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController?.showsSearchResultsController = false
        showSuggestions()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        hideSuggestions()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "RecentSearchCell")
        }
        
        let query = recentSearches[indexPath.row]
        cell.textLabel?.text = query.keyword
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let query = recentSearches[indexPath.row]
        search(query: query)
        
        searchController?.searchBar.text = query.keyword
        searchController?.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }
}

