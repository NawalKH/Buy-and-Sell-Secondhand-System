//
//  ItemViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 10/29/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
   
    @IBOutlet weak var itemSellerName: UILabel!
    @IBOutlet weak var itemSellerRating: UILabel!
    @IBOutlet weak var itemSellerPhoto: UIImageView!
    
    var itemDetail:Item?
   
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.image=UIImage(named: (itemDetail?.imageURL!)!)
        itemName.text=itemDetail?.name
        itemLocation.text=itemDetail?.location
        itemDescription.text="Description:   \((itemDetail?.description)!)"
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MakeOffer(_ sender: Any) {
    }
    @IBAction func Ask(_ sender: Any) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
