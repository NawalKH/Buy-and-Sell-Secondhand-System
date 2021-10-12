//
//  EditAccountViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 26/11/2017.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {


    var ID:String = (Auth.auth().currentUser?.uid)!
    

    var databaseref: DatabaseReference!
    var storageref: StorageReference!
    

    @IBOutlet var image: UIImageView!
   // @IBOutlet var email: UITextField!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname:UITextField!
    
    
    // var userEmail:String = " "
    
    var userFirst:String = " "
    var userLast:String = " "
    var changed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
          lastname.textColor=UIColor.lightGray
         firstname.textColor=UIColor.lightGray
       
        
        var addButton: UIBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.save))
         self.navigationItem.rightBarButtonItem = addButton
        
        databaseref = Database.database().reference()
        storageref = Storage.storage().reference()
        
        setProfileInfo()
        
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.borderWidth = 1.5
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setProfileInfo(){
        
        
        self.databaseref!.child("Users/\(ID)").observeSingleEvent(of: .value, with: {(snapshot) in
            let values = snapshot.value as? NSDictionary
            
            if let profileimg = values?["ProfilePic"] as? String
            { self.image.sd_setImage(with: URL(string: profileimg)) }
            
            if let first = values?["FirstName"] as? String
            { self.firstname.text = first }
            
            if let last = values?["LastName"] as? String
            { self.lastname.text = last }
            
  
        })
        
    }

    @IBAction func changePhotot(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self 
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        changed = true
        if let Image = info [UIImagePickerControllerOriginalImage] as? UIImage
        {  image.image = Image }
        self.dismiss(animated: true, completion: nil)}
    
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    @objc func save(){
  
    
        //let userId = FirebaseApp.auth()?.currentUser?.uid{
        
        if (changed){
            let imgref = storageref.child("ProfilePics").child(ID)
            guard let uploadedimg = image.image else {return}
            
            //update photo
            if let newimg = UIImagePNGRepresentation(uploadedimg){
                
                //upload image to firebase
                imgref.putData(newimg, metadata: nil, completion: {(metadate , error) in
                    if error != nil
                    { print(error!)
                        return }
                    
                    imgref.downloadURL(completion: {(url , error) in
                        if error != nil
                        { print(error!)
                            return }
                        
                        if let profilephotourl = url?.absoluteString {
                            self.databaseref!.child("Users/\(self.ID)/ProfilePic").setValue(profilephotourl)}
                    })
                })
            }
        }
        
        //update email

        
      /*  let user = Auth.auth().currentUser
        let userEmail=user?.email
       
        if (email.text != userEmail)
        {
        user?.updateEmail(to: "bob_smith_cpa@gmail.com") { error in
            if let error = error {
                // An error happened.
            } else {
                // Email updated.
            }
            }}*/
        
        //name from textfield
        let FnameField:String = firstname.text!
        let LnameField:String = lastname.text!
        
        //update first name
        if (firstname.text != userFirst)
        { self.databaseref!.child("Users/\(ID)/FirstName").setValue(firstname.text) }
        
        
        //update last name
        if (lastname.text != userLast)
        { self.databaseref!.child("Users/\(ID)/LastName").setValue(lastname.text) }
        
        
        _ = navigationController?.popViewController(animated: true)
        
    }

}
