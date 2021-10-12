//
//  itemTableViewCell.swift
//  Dlalah
//
//  Created by Lama Alashed on 29/11/2017.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit

class itemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    var info: Item = Item(ItemKey: "", name: "", description: "", price: "", imageURL: "", category:"" ,location:"" , sellerUID:"")

    func setItem(item: Item){
    //    info = topic
        self.itemImage.sd_setImage(with: URL(string: item.imageURL))
        self.itemName.text = item.name
    }
    
    func getId() -> String {
       return info.ItemKey
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
