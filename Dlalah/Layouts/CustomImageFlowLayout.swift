//
//  CustomImageFlowLayout.swift
//  Dlalah
//
//  Created by Hend Alzahrani on 10/19/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        
        set {}
        
        get {
            let numberOfColumns: CGFloat = 2
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
            
            return CGSize(width: itemWidth, height: itemWidth)
            
        }
    }

    func setupLayout(){
        minimumLineSpacing = 10
        minimumInteritemSpacing = 0
        scrollDirection = .vertical
        
    }
    
}
