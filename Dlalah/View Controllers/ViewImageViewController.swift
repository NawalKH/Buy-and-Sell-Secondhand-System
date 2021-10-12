//
//  ViewImageViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 11/7/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit

class ViewImageViewController: UIViewController {

    @IBOutlet weak var Fullimage: UIImageView!
     var imagev : String = ""
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
         Fullimage.sd_setImage(with : URL (string:imagev))

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
