//
//  ImageCollectionViewCell.swift
//  Dlalah
//
//  Created by Hend Alzahrani on 10/19/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
 
    
    @IBOutlet weak var price: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.price.text = ""

    }
}
