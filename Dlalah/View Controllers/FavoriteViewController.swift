//
//  FavoriteViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 11/8/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase

class FavoriteViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{

    
    @IBOutlet weak var tableView: UITableView!
    
    var favItems = [Item]()
    var user: User?
    var selectedItem: Item!
    var dbRef: DatabaseReference!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        if (Auth.auth().currentUser?.uid==nil){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(vc!, animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor(displayP3Red: 25/255, green: 149/255, blue: 173/255, alpha: 1.0)]

            self.fetchData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (Auth.auth().currentUser?.uid==nil){
            print("no user yet")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(vc!, animated: true, completion: nil)
        }
        else
        {
            self.fetchData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSections(in favTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.favItems.count == 0 {
            return 1
        } else {
            return self.favItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.favItems.count == 0 {
            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
        } else {
            return 80
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.favItems.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavCell
            cell.clearCellData()
            
            if(self.favItems[indexPath.row].name != ""){
            
             cell.itemPic.sd_setImage(with: URL(string: self.favItems[indexPath.row].imageURL), placeholderImage: UIImage(named: "unfound"))
            cell.itemName.text = self.favItems[indexPath.row].name
                cell.itemLocation.text = self.favItems[indexPath.row].location
            cell.itemPrice.text = "\((self.favItems[indexPath.row].price)!)SR"
                cell.itemLocation.textColor = GlobalVariables.darkCyan
            }
            else{
                cell.itemName.text = "This item is not available anymore."
                cell.itemName.font = cell.itemName.font.withSize(15)
                cell.itemPic.image = UIImage(named: "unfound")
                cell.itemLocation.text = "Remove Item"
                cell.itemPrice.text = ""
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.favItems.count > 0 {
            //self.selectedItem = self.favItems[indexPath.row];
            //self.performSegue(withIdentifier: "segue", sender: favItems[indexPath.row])
            if(favItems[indexPath.row].name != ""){
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ItemDViewController") as! ItemDViewController
            myVC.itemDetail = favItems[indexPath.row]
            navigationController?.pushViewController(myVC, animated: true)
            }
            else{
                
                let currentUserID = Auth.auth().currentUser?.uid
               let ref =  Database.database().reference().child("favorites").child(currentUserID!).child((favItems[indexPath.row].ItemKey)!)
                
                ref.removeValue(completionBlock: { (error, refer) in
                    if error != nil {
                        print(error!)
                    } else {
                        print(refer)
                        print("Fave Removed Correctly")
                    }
                    
                })
            }
        }
    }
    
    func fetchData() {
        let currentUserID = Auth.auth().currentUser?.uid
    Database.database().reference().child("favorites").child(currentUserID!).observe(.value, with : {(snapShot) in
            var favs = [Item]()
            if let val = snapShot.value as? NSDictionary {
                
                for(key,_) in val {
                    let itemK = (key as? String)!
                    Database.database().reference().child("Items").child(itemK).observeSingleEvent(of: .value, with : { (snapShot2) in
                        
                        let itemObject = Item(snapshot: snapShot2)
                        favs.append(itemObject)
                        self.favItems = favs
                        print("favs: ")
                        print(favs)
                       self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                        
                    })
                }

            }
        self.activityIndicator.stopAnimating()
        })
        
        DispatchQueue.main.async {
                self.tableView.reloadData() }

    }

}
