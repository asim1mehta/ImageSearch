//
//  FetchTask.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

/// Provides abstraction for Tasks which are created to fetch Data for example: 'URLSessionDataTask'
protocol CancelableTask {
    func cancel()
}
