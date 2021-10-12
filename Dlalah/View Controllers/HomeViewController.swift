//
//  HomeViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 10/12/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging
import SDWebImage
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var usercity:String!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var tagCollection: UICollectionView!
    @IBOutlet weak var location: UILabel!

    var customImageFlowLayout: CustomImageFlowLayout!
    
    var images = [Item]()
    
    var tags = ["All","Electronics", "Furniture", "Computers", "Cars", "Books", "Clothing","Food"]
   
    var colors = [UIColor]()

    var dbRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //JUST TESTING GETTING THE NOTIFICATION TOKEN
        if ((Auth.auth().currentUser?.uid) != nil){
        let token = Messaging.messaging().fcmToken
            if(token != nil){
                User.updateUserToken()
            }
        }

        self.navigationController?.navigationBar.titleTextAttributes=[NSAttributedStringKey(rawValue: NSAttributedStringKey(rawValue: NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue).rawValue).rawValue):UIColor.red]
        setColors()
        dbRef = Database.database().reference().child("Items")

        customImageFlowLayout = CustomImageFlowLayout()
        imageCollection.collectionViewLayout = customImageFlowLayout
        imageCollection.backgroundColor = .white
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopMonitoringSignificantLocationChanges()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationAuthStatus()
    }
    
    
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    
   let location = CLLocation(latitude: currentLocation.coordinate.latitude , longitude: currentLocation.coordinate.longitude)
        
        fetchCountryAndCity(location: location) {
            country, city in
            self.usercity=city
            self.location.text=city+", "+country
 
        
        
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
        }
        else{
            print("disConnected")
            self.showToast(message: "You Not are connected")
        }
        
        self.loadDB(cat: "All")
        
        
            
        }
 
 
 
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }


    func fetchCountryAndCity (location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
 
    
    func loadDB(cat: String){
        
        
        if (cat == "All"){
        dbRef.observe(DataEventType.value, with: { (snapshot) in var newItems = [Item]()
            
            for itemSnapshot in snapshot.children {
                let itemObject = Item(snapshot: itemSnapshot as! DataSnapshot)
                
                //append only the items which have the same location as the user's location
                
                
                
                if(itemObject.location == self.usercity){
                newItems.append(itemObject)
                }
                
            }
            
                self.images = newItems
                self.imageCollection.reloadData()
        })
            
        }
        
        else {
            
            dbRef.observe(DataEventType.value, with: { (snapshot) in var newItems = [Item]()
                
                for itemSnapshot in snapshot.children {
                    let itemObject = Item(snapshot: itemSnapshot as! DataSnapshot)
                    
                    //append only the items which have the same location as the user's location
                    
                    
                    
                    if(itemObject.category == cat){
                        newItems.append(itemObject)
                    }
                    
                }
                
                self.images = newItems
                self.imageCollection.reloadData()
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView (  _ collectionView: UICollectionView, numberOfItemsInSection section: Int ) -> Int {
        
        if collectionView == self.imageCollection {
       return images.count
        }
        
        return tags.count
    }
    
    func collectionView (  _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        
        if collectionView == self.imageCollection{

        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
            
            cell.layer.cornerRadius=10 //set corner radius here
        
        let item = images[indexPath.row]
        
        cell.imageView.sd_setImage(with: URL(string: item.imageURL), placeholderImage: UIImage(named: "image1"))
            
            
        cell.price.layer.masksToBounds = true
        cell.price.layer.cornerRadius = 10
            
        cell.price.text = "  "+item.price+"SR"+"  "
        
        return cell
            
        }
        
        else {
            let cell = tagCollection.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagsCollectionViewCell
            
            cell.Category.setTitle(tags[indexPath.row],for: .normal)
           cell.Category.backgroundColor = colors[indexPath.row]
            cell.Category.addTarget(self, action: #selector(
                HomeViewController.searchCat(sender:)), for: .touchUpInside)
            return cell
        }
  
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
            return 10.0
    
    }
    
    @objc func searchCat(sender: UIButton) {
        
        if let btnTitle = sender.title(for: .normal) {
            loadDB(cat: btnTitle)
        }

    }
    //  send item's id to itemViewController to view item's details
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: images[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let des=segue.destination as? ItemDViewController {
                if let item=sender as? Item {
                    des.itemDetail=item
                }
            }
        }
    }
    
    
    func setColors() {
        for _ in 1...3 {
        colors.append(UIColor(displayP3Red: 25/255, green: 149/255, blue: 173/255, alpha: 1.0))
        
        colors.append(UIColor(displayP3Red: 188/255, green: 186/255, blue: 190/255, alpha: 1.0))
        
        colors.append(UIColor(displayP3Red: 237/255, green: 87/255, blue: 82/255, alpha: 1.0))
        
        colors.append(UIColor(displayP3Red: 161/255, green: 214/255, blue: 226/255, alpha: 1.0))
            
        }
    }
}


