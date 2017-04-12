//
//  ImageCell.swift
//  Test
//
//  Created by framgia on 4/11/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    private var imageView: UIImageView!
    var image: UIImage? {
        didSet {
            imageView.frame = self.bounds
            imageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.clipsToBounds = true
    }
    
}
