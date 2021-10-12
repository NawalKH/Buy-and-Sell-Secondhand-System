//  SellViewController.swift
//  Dlalah
//  Created by Nawal Kh on 2/11/1439 AH.
//  Copyright © 1439 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SellViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
     let tags = ["Electronics", "Furniture", "Computers", "Cars", "Books", "Clothing","Food"]
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDesc: UITextView!
    @IBOutlet weak var itemLocation: UITextField!
    @IBOutlet weak var itemCategory: UIPickerView!
    
    var imageUrl = String()

    
    let userID = Auth.auth().currentUser!.uid
    var cat=""

    var itemImage = UIImage()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cat=tags[row]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        itemDesc!.layer.borderWidth = 0.5
        itemDesc!.layer.cornerRadius = 5
        itemDesc!.layer.borderColor = UIColor.lightGray.cgColor
        
        itemName.delegate = self
        itemPrice.delegate = self
        itemDesc.delegate = self
        itemLocation.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func sell(_ sender: Any) {
     
        let storageRef: StorageReference!
        storageRef = Storage.storage().reference()
        
        //create an access point for the Firebase storage
        let imageName=NSUUID().uuidString //This will generate a unique string
        let storageItem = storageRef.child("Items/"+imageName)
        
     //Define the image type
        let metadata =  StorageMetadata()
        metadata.contentType="image/jpeg"
        
        if (itemName.text == "" || itemPrice.text == "" || itemLocation.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please fill the missing information", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else
        {
        if let uploadedData = UIImageJPEGRepresentation(itemImage,0.8)
        {
            storageItem.putData(uploadedData, metadata: metadata, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                
                if let itemImageUrl = metadata?.downloadURL()?.absoluteString{
                    let values = [ "name": self.itemName.text!, "description":self.itemDesc.text!, "location":self.itemLocation.text!, "price":self.itemPrice.text!, "url":itemImageUrl, "seller":self.userID, "category":self.cat]
                    
                    
                    self.addItem(values: values)
                    
                }
                    
                    
                var alert = UIAlertController(title:"successfully puplished",message:"",preferredStyle: UIAlertControllerStyle.alert)
                
                let loginAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                    self.performSegue(withIdentifier: "published", sender:self)
                }
                
                alert.addAction(loginAction)
                
                self.present(alert, animated: true, completion: nil)
                
                
                     self.redirectToHome()
                    
                }
               ) }
        }
    }
    
    
    func redirectToHome(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    private func addItem(values:[String: String]){
        
        let ref : DatabaseReference!
        ref = Database.database().reference()
        let newItem = ref.child("Items").childByAutoId()
        newItem.setValue(values)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
}
