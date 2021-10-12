//
//  RegistrationViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 10/8/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var Lastname: UITextField!
    @IBOutlet weak var EmailR: UITextField!
    @IBOutlet weak var PasswordR: UITextField!
    @IBOutlet weak var cPawwordR: UITextField!
    
    @IBOutlet weak var signupdesign: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirstName.setBottomBorder()
        Lastname.setBottomBorder()
        EmailR.setBottomBorder()
        PasswordR.setBottomBorder()
        cPawwordR.setBottomBorder()
        
        signupdesign.layer.cornerRadius=7
        signupdesign.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Signup(_ sender: Any) {
        signup()
    }
    
    
    func signup(){
        
        let ref : DatabaseReference!
        ref = Database.database().reference()
        var a=false
        var b=false
        
        if PasswordR.text == cPawwordR.text {
            a = true }
        else{
            let alertController = UIAlertController(title: "Error", message: "Passwords dont match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)}
        
        if (EmailR.text == "" || cPawwordR.text == "" || cPawwordR.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else{
            b = true
            
            if a == true && b == true{
                Auth.auth().createUser(withEmail: EmailR.text!, password: PasswordR.text!) { (user, error) in
                    
                    
                    if error == nil {
                        print("You have successfully signed up")
                        // following method is a add user's  more details
                        
                        
                        ref.child("Users").child(user!.uid).setValue([ "FirstName": self.FirstName.text!, "LastName":self.Lastname.text!, "Location":"", "ProfilePic":"", "RateCounter":"0", "RateValue":"0"])
                        
                        //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                        
                        self.presentLoggedInScreen()
                        
                        
                    }
                        
                    else  {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }//end signup func
    
    func presentLoggedInScreen(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // fire when someone click on return
        signup()
        self.view.endEditing(true)
        return true
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
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}



