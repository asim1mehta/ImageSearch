//
//  ListItem.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

protocol SearchResult {
    var id: String {get}
    var previewURL: String {get}
    var fullScreenURL: String {get}
}
