//
//  SmallImageCollectionViewCell.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setImageWith(url: URL?) {
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImg"))
    }
    
    func setImageWith(previewURL: URL?, fullScreenURL: URL?) {
        var placeholder: UIImage?
        if let imageKey = previewURL?.absoluteString,ImageCache.default.isCached(forKey: imageKey) {
            placeholder = ImageCache.default.retrieveImageInMemoryCache(forKey: imageKey)
        }
        
        imageView.kf.setImage(with: fullScreenURL, placeholder: placeholder)
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
    }
}
