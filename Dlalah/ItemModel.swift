//
//  ItemModel.swift
//  Dlalah
//
//  Created by Hend Alzahrani on 10/15/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ItemModel {
    
    let key:String!
    let name:String!
    let description:String!
    let category:String!
    let pic:String!
    let price:String!
    let sellerUID:String!
    let location:String!
    
    let itemRef:DatabaseReference?
    
    init (key:String = "", name:String, description:String, category:String,  pic:String,  price:String,  sellerUID:String, location:String) {
        self.key = key
        self.name = name
        self.description = description
        self.category = category
        self.pic = pic
        self.price = price
        self.sellerUID = sellerUID
        self.location = location
        
        self.itemRef = nil
    }
    
    init (snapshot:DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        if let itemName = snapshot.value!["name"] as? String {
            name = itemName
        }else {
            name = ""
        }
        
        if let ItemDescription = snapshot.value!["description"] as? String {
            description = ItemDescription
        }else {
            description = ""
        }
        
        
        if let ItemCategory = snapshot.value!["category"] as? String {
            category = ItemCategory
        }else {
            category = ""
        }
        
        
        if let ItemPic = snapshot.value!["pic"] as? String {
            pic = ItemPic
        }else {
            pic = ""
        }
        
        if let ItemPrice = snapshot.value!["price"] as? String {
            price = ItemPic
        }else {
            price = ""
        }
        
        
        if let ItemSeller = snapshot.value!["sellerUID"] as? String {
            sellerUID = ItemSeller
        }else {
            sellerUID = ""
        }
        
        if let ItemLocation = snapshot.value!["location"] as? String {
            location = ItemLocation
        }else {
            location = ""
        }
        
        
    }
    
    func toAnyObject() -> AnyObject {
        return ["name":name, "description":description, "category":category, "pic":pic, "price":price, "sellerUID":sellerUID, "location":location]
    }
    
}
