//
//  FavSell.swift
//  Dlalah
//
//  Created by Nawal Kh on 3/9/1439 AH.
//  Copyright © 1439 Lama Alashed. All rights reserved.
//

import UIKit

class FavCell: UITableViewCell {

    @IBOutlet weak var itemPic: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var itemLocation: UILabel!
    
    
    func clearCellData()  {
        self.itemName.font = UIFont(name:"AvenirNext-Regular", size: 17.0)
        self.itemLocation.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
        self.itemPrice.font = UIFont(name:"AvenirNext-Regular", size: 13.0)
        self.itemPic.layer.borderColor = GlobalVariables.cyan.cgColor
        self.itemLocation.textColor = UIColor.rbg(r: 111, g: 113, b: 121)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemPic.layer.borderColor = GlobalVariables.cyan.cgColor
    }
}
