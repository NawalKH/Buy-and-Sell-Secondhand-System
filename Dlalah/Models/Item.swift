//
//  Item.swift
//  Dlalah
//
//  Created by Hend Alzahrani on 10/19/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct Item {
    
    let ItemKey: String!
    let name: String!
    let description: String!
    let price: String!
    let imageURL: String!
    let category: String!
    let location: String!
    let sellerUID: String!
    
    let itemRef: DatabaseReference?
    
    init(ItemKey: String, name: String, description: String, price: String, imageURL: String, category: String, location: String, sellerUID: String) {
       
        self.ItemKey = ItemKey
         self.name = name
         self.description = description
         self.price = price
         self.imageURL = imageURL
         self.category = category
         self.location = location
         self.sellerUID = sellerUID
        
        self.itemRef = nil
        
    }
    
    init(snapshot: DataSnapshot) {
        ItemKey = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let url = snapshotValue?["url"] as? String {
            imageURL = url
        } else {
            imageURL = ""
        }
        
        
        if let iname = snapshotValue?["name"] as? String {
            name = iname
        } else {
            name = ""
        }
        
        
        if let desc = snapshotValue?["description"] as? String {
            description = desc
        } else {
            description = ""
        }
        
        if let p = snapshotValue?["price"] as? String {
            price = p
        } else {
            price = ""
        }
        
        
        if let seller = snapshotValue?["seller"] as? String {
            sellerUID = seller
        } else {
            sellerUID = ""
        }
        
        
        if let cat = snapshotValue?["category"] as? String {
            category = cat
        } else {
            category = ""
        }
        
        
        if let loc = snapshotValue?["location"] as? String {
            location = loc
        } else {
            location = ""
        }
   
    }
    
    static func updateItem(itemID: String, withValues: [String: Any]){
        
        let ref  = Database.database().reference()
        
        ref.child("Items").child(itemID).updateChildValues(withValues, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            print("Item Successfully Updated")
        })
        
    }
    
    static func deleteItem(itemID: String){
        
        let ref  = Database.database().reference()
        
        ref.child("Items").child(itemID).removeValue(completionBlock: { (error, refer) in
            if error != nil {
                print(error!)
            } else {
                print(refer)
                print("Child Removed Correctly")
            }
            
        })
        
    }
    
    
    func isFaved(completion: @escaping (_ success: Bool) -> ()){
        print("checking if faved")
        let currentUser : String = (Auth.auth().currentUser?.uid)!
        var flag = false
        Database.database().reference().child("favorites").child(currentUser).observeSingleEvent(of: .value, with : {(snapShot) in
            
            if let val = snapShot.value as? NSDictionary {
                
                for(key,_) in val {
                    if(self.ItemKey == key as? String){
                        flag = true
                        print("found the item favorited")
                    }
                }
            }
            completion(flag)
        })
    }
    
    
    
}
