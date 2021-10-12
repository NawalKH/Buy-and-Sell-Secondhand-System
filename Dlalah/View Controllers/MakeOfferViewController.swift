//
//  MakeOfferViewController.swift
//  Dlalah
//
//  Created by Nawal Kh on 2/29/1439 AH.
//  Copyright © 1439 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase

class MakeOfferViewController: UIViewController,UITextFieldDelegate{

  
    @IBOutlet weak var offer: UITextField!
    
    var user: User?
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offer.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func dismissPopup (_ sender: UIButton){
        
        dismiss(animated:true, completion:nil)
    }
    


    @IBAction func makeOffer (_ sender: UIButton){
        
        
        if(offer.text != ""){
            let content = "Hello! I have a new offer for your item:  "+offer.text!+"$"
            let message = Message.init(type: .text, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
            Message.send(message: message, toID: (self.user?.id)!, completion: {(_) in
                
                let message2 = Message.init(type: .offer, content: self.imageURL, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
                Message.send(message: message2, toID: (self.user?.id)!, completion: {(_) in
                })
            })
            
            let myID = (Auth.auth().currentUser?.uid)
            
            if(self.user?.token != ""){
                User.info(forUserID: myID!) { (user) in
                    
                    Message.sendNotification(msg: "You have recieved a new offer!", userName: (user.name), userToken: (self.user?.token)!)
                }
            }

            let message3 = " Offer Sent "
            let alert = UIAlertController(title: nil, message: message3, preferredStyle: .alert)
            self.present(alert, animated: true)
            
            // duration in seconds
            let duration: Double = 2
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                alert.dismiss(animated: true)
            }
           // self.performSegue(withIdentifier: "chatSegue", sender: self)
            
              dismiss(animated:true, completion:nil)
            
        }
        
    }
    
}
