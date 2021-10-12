//
//  LogInViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 10/8/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    
    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    
    @IBOutlet weak var buttondesign: UIButton!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        Email.setBottomBorder()
        Password.setBottomBorder()
        
        buttondesign.layer.cornerRadius=7
        buttondesign.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        login()
    }
    
    
    func login(){
        if self.Email.text == "" || self.Password.text == ""  {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            print("fail 1 ")
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            // if email and paaword are filled
            
            Auth.auth().signIn(withEmail: self.Email.text!, password: self.Password.text!) { (user, error) in
                
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    let vcp = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                    self.present(vcp!, animated: true, completion: nil)
                    print("sent")
                    
                }
                    
                    
                else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    print("fail 2")
                }
            }
            
        }
        
        
    }//end of login func
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // fire when someone click on return
        login()
        self.view.endEditing(true)
        return true
    }
    
    
    
}

