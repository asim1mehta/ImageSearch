//
//  ListItem.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

///SearchResult: Protocol to give abstraction to search results
protocol SearchResult {
    var uId: String {get}
    var thumbnailURL: URL? {get}
    var fullScreenURL: URL? {get}
}
