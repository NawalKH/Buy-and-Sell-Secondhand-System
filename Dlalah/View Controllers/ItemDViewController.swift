//
//  ItemDViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 11/7/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase
import Social

class ItemDViewController: UIViewController {

   
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemDes: UITextView!
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var itemSellerPhoto: UIImageView!
    @IBOutlet weak var itemSellerName: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var offerButton: UIButton!
    var selectedUser: User?
    @IBOutlet weak var askButton: UIButton!
    
    @IBOutlet weak var rating: CosmosView!
    
    var first:String = " "
    var last:String = " "
    var ratingValue:String = " "
    var ratingCount:String = " "
    var photo:String = " "
    var userToken: String = ""

    var flag = 0;
    var sInfo = false
    var favInfo = false

    var itemDetail:Item?
     
    var ref: DatabaseReference!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        flag = 0
        ref = Database.database().reference()
        
        let shareButton: UIBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(self.share))
        self.navigationItem.rightBarButtonItem = shareButton
        
        
        if (Auth.auth().currentUser?.uid==nil){
            self.favButton.isHidden = true
        }
        else{
        itemDetail?.isFaved(){
            (success) -> Void in
            if(success){
                let image = UIImage(named: "favorite") as UIImage?
                let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                self.favButton.setImage(tintedImage, for: [])
                self.favButton.tintColor = GlobalVariables.lightRed
                self.flag = 1
            }
            else{
                let image = UIImage(named: "favorite2") as UIImage?
                let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                self.favButton.setImage(tintedImage, for: [])
                self.favButton.tintColor = GlobalVariables.lightRed
                self.flag = 0
                
            }
        }
        }
        
        itemImage.sd_setImage(with : URL (string:itemDetail!.imageURL))
        itemName.text=itemDetail?.name
        itemLocation.text=itemDetail?.location
        itemPrice.text="\((itemDetail?.price)!) SR"
        //itemDescription.text="Description:   \((itemDetail?.description)!)"
        itemDescription.text="Description:"
        itemDes.text=itemDetail?.description
        itemSellerPhoto.layer.cornerRadius=14
        rating.settings.fillMode = .precise
        setsellerinfon()
       
        if(itemDetail?.sellerUID == Auth.auth().currentUser?.uid){
            setSellerButtons()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (Auth.auth().currentUser?.uid != nil){
        itemDetail?.isFaved(){
            (success) -> Void in
            if(success){
                let image = UIImage(named: "favorite") as UIImage?
                let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                self.favButton.setImage(tintedImage, for: [])
                self.favButton.tintColor = GlobalVariables.lightRed
                self.flag = 1
            }
            else{
                let image = UIImage(named: "favorite2") as UIImage?
                let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                self.favButton.setImage(tintedImage, for: [])
                self.favButton.tintColor = GlobalVariables.lightRed
                self.flag = 0
                
            }
        }
        }
    }
    
    
    func setSellerButtons() {
        offerButton.setTitle("Edit", for: .normal)
        askButton.setTitle("Delete", for: .normal)
        askButton.backgroundColor = GlobalVariables.lightRed
        
    }
    
    func setsellerinfon(){
        
        //set fullname , username , img
        self.ref!.child("Users/\((itemDetail?.sellerUID)!)").observe(.value , with: {(snapshot) in
            if (snapshot.value as? [String:Any]) != nil {
                
                //retrieve
                if ((snapshot.childSnapshot(forPath: "FirstName").exists()) == true)
                { self.first = snapshot.childSnapshot(forPath: "FirstName").value as! String }
                if ((snapshot.childSnapshot(forPath: "LastName").exists()) == true)
                { self.last = snapshot.childSnapshot(forPath: "LastName").value as! String }
                if ((snapshot.childSnapshot(forPath: "RateValue").exists()) == true)
                { self.ratingValue = snapshot.childSnapshot(forPath: "RateValue").value as! String }
                if ((snapshot.childSnapshot(forPath: "RateCounter").exists()) == true)
                { self.ratingCount = snapshot.childSnapshot(forPath: "RateCounter").value as! String }
                if ((snapshot.childSnapshot(forPath: "ProfilePic").exists()) == true)
                {  self.photo = snapshot.childSnapshot(forPath: "ProfilePic").value as! String }
                if ((snapshot.childSnapshot(forPath: "tokenID").exists()) == true)
                {  self.userToken = snapshot.childSnapshot(forPath: "tokenID").value as! String }
                //set
                self.itemSellerName.text = "\(self.first) \(self.last)"
                if(self.photo != "")
                {
                    self.itemSellerPhoto.sd_setImage(with: URL(string: self.photo))
                }else{
                    self.itemSellerPhoto.image=UIImage(named: "profilebold")
                }
                
                self.rating.text = "("+self.ratingCount+")"
                if let ratVal = Double(self.ratingValue){
                    self.rating.rating = ratVal
                }else{
                   self.rating.rating = 0
                }
                           }
        }
        )
 
        User.info(forUserID: (itemDetail?.sellerUID)!) { (user) in
         self.selectedUser = user
         }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "askSegue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
        
        if segue.identifier == "offerSegue" {
            let vc = segue.destination as! MakeOfferViewController
            vc.user = self.selectedUser
            vc.imageURL = itemDetail!.imageURL
        }
        
        if segue.identifier == "editSegue" {
            let vc = segue.destination as! EditItemViewController
            vc.item = itemDetail
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func makeOffer(_ sender: Any) {
        if(itemDetail?.sellerUID == Auth.auth().currentUser?.uid){
            self.performSegue(withIdentifier: "editSegue", sender: self)
        }
        else{
            performSegue(withIdentifier: "offerSegue", sender: nil)
        }
    }
    
    
    @IBAction func ask(_ sender: Any) {
    }
    
    
    @IBAction func viewFullImage(_ sender: Any) {
        
       let myVC = storyboard?.instantiateViewController(withIdentifier: "ViewImageViewController") as! ViewImageViewController
        myVC.imagev = ((itemDetail?.imageURL)!)
        navigationController?.pushViewController(myVC, animated: true)
    }
    

    @IBAction func secprofilebtn(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        myVC.ID = ((itemDetail?.sellerUID)!)
        navigationController?.pushViewController(myVC, animated: true)
        
    }
    
    @IBAction func profileBtn(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        myVC.userID = ((itemDetail?.sellerUID)!)
        navigationController?.pushViewController(myVC, animated: true)
    }
    
     @IBAction func openChat(_ sender: Any) {
        if(itemDetail?.sellerUID == Auth.auth().currentUser?.uid){
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
                self.deleteItem()
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(cancel)
            dialogMessage.addAction(ok)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
        else{
            self.performSegue(withIdentifier: "askSegue", sender: self)
        }
     }
    
    func deleteItem()
    {
        Item.deleteItem(itemID: (itemDetail?.ItemKey)!)
        
        let message = " Item is deleted Successfully "
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        // duration in seconds
        let duration: Double = 1
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    @IBAction func PressFav(_ sender: Any) {
        
         let currentUserID = Auth.auth().currentUser?.uid
        if(flag == 0)
        {
            let image = UIImage(named: "favorite") as UIImage?
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            self.favButton.setImage(tintedImage, for: [])
            self.favButton.tintColor = GlobalVariables.lightRed
            flag = 1

            let ref : DatabaseReference!
            
            ref = Database.database().reference()
            let newItem = ref.child("favorites").child(currentUserID!).child((itemDetail?.ItemKey)!)
            newItem.setValue(" ")
        }
        else {
            let image = UIImage(named: "favorite2") as UIImage?
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            self.favButton.setImage(tintedImage, for: [])
            self.favButton.tintColor = GlobalVariables.lightRed
            flag = 0
            
            //delete
            ref =  Database.database().reference().child("favorites").child(currentUserID!).child((itemDetail?.ItemKey)!)
 
                ref.removeValue(completionBlock: { (error, refer) in
                if error != nil {
                    print(error!)
                } else {
                    print(refer)
                    print("Fave Removed Correctly")
                }
                
            })
 
        }
    }
    
    
    
    @objc func share() {

        let shareText = "\(itemDetail?.name as! String) Is On Sale at Dlalah app for \(itemDetail?.price as! String) "
        
        if let image=itemImage.image {
            let vc = UIActivityViewController(activityItems: [shareText,image],applicationActivities: [])
            present(vc, animated: true, completion: nil)}
    }
    
    
    func showAlert(service:String)
    {
        let alert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
