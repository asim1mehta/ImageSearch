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
}
