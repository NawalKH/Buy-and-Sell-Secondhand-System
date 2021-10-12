//
//  ChangepassViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 26/11/2017.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ChangepassViewController: UIViewController {

    var ref = Auth.auth()
    
    let ID:String = (Auth.auth().currentUser?.uid)!
    
    let email:String = (Auth.auth().currentUser?.email)!
    
    @IBOutlet weak var current: UITextField!
    
    @IBOutlet weak var new: UITextField!
    
    @IBOutlet weak var verifyNew: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        var addButton: UIBarButtonItem = UIBarButtonItem(title: "Change", style: .done, target: self, action: #selector(self.change))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func change(){

        let credential = EmailAuthProvider.credential(withEmail: email, password: current.text!)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
            if error != nil {
                let alert = UIAlertController(title: "", message: "The password you entered was invalid. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                if self.new.text == self.verifyNew.text {
                    Auth.auth().currentUser?.updatePassword(to: self.new.text!, completion: { (action) in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                }
                else {
                    let alert = UIAlertController(title: "", message: "The new password and confirmation password do not match.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // fire when someone click on return
       // login()
        self.view.endEditing(true)
        return true
    }
    
}




