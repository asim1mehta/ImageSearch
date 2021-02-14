//
//  SearchViewController+Suggestions.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import UIKit

extension SearchViewController {
    func showSuggestions() {
        loadNewSuggestions()
        
        self.tableView.alpha = 0
        self.tableView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }

        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func hideSuggestions() {
        self.tableView.isHidden = true
    }
    
    private func loadNewSuggestions() {
        recentSearches = RecentSearchStore.all()
    }
}
