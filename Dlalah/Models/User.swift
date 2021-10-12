//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation
import UIKit
import Firebase
import FirebaseMessaging

class User: NSObject {
    
    //MARK: Properties
    let name: String
    let id: String
    var profilePic: UIImage
    var token: String
    //MARK: Methods
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("Users").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let fname = value?["FirstName"] as? String ?? ""
            let lname = value?["LastName"] as? String ?? ""
            let name = fname+" "+lname
            let profileURL = value?["ProfilePic"] as? String ?? ""
            var profilePic: UIImage
            let token = value?["tokenID"] as? String ?? ""
            if(profileURL == ""){
                profilePic = UIImage.init(named: "default")!
            }
            else{
            let url = URL(string:profileURL)
            
            let data = try? Data(contentsOf: url!)
            
            profilePic = UIImage(data: data!)!
            }
            let user = User.init(name: name, id: forUserID, profilePic: profilePic, token: token)
            completion(user)
        })
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }
    
    
    class func isUserRated(userId: String, completion: @escaping (_ success: Bool) -> ()){
 
        let currentUser : String = (Auth.auth().currentUser?.uid)!
        var flag = false
        
        Database.database().reference().child("Ratings").child(currentUser).observeSingleEvent(of: .value, with : {(snapShot) in
            
            if let val = snapShot.value as? NSDictionary {
                
                for(key,_) in val {
                    if(userId == key as? String){
                        flag = true
                        print("found the user rated")
                    }
                }
            }
            completion(flag)
        })
    }
    
    class func rateUser(userId: String, rating: Double){
        var oldRate: Double = 0.0;
        var count: Double = 0;
        
        Database.database().reference().child("Users").child(userId).observeSingleEvent(of: .value , with: {(snapshot) in
            if (snapshot.value as? [String:Any]) != nil {
                //retrieve
                let ratingVal = snapshot.childSnapshot(forPath: "RateValue").value as! String
                let counter = snapshot.childSnapshot(forPath: "RateCounter").value as! String
               
                oldRate = Double(ratingVal)!
                count = Double(counter)!
                print(oldRate)
                let newRate = ((oldRate*count)+rating)/(count+1)
                count = count + 1
                let countInt = Int(count)
                let withValues = ["RateValue": String(format:"%.2f", newRate), "RateCounter": String(format:"%d", countInt)]
                
                Database.database().reference().child("Users").child(userId).updateChildValues(withValues, withCompletionBlock: { (error, ref) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    print("User Rate Updated")
                })
                
                let currentUser : String = (Auth.auth().currentUser?.uid)!
                Database.database().reference().child("Ratings").child(currentUser).child(userId).setValue("  ")
            }
        })

    }
    
    class func updateUserToken(){
        
         let userId : String = (Auth.auth().currentUser?.uid)!
        let userToken: String = Messaging.messaging().fcmToken!
         let withValues = ["tokenID": userToken]
        
        Database.database().reference().child("Users").child(userId).updateChildValues(withValues, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            print("Token Successfully Updated")
        })
    }
    
    //MARK: Inits
    init(name: String, id: String, profilePic: UIImage, token: String) {
        self.name = name
        self.id = id
        self.profilePic = profilePic
        self.token = token
    }
    
    
}
