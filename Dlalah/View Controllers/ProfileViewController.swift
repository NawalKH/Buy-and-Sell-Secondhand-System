//
//  ProfileViewController.swift
//  Dlalah
//
//  Created by Lama Alashed on 11/7/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var userID : String = ""

    @IBOutlet var profileUser: UILabel!
    
    
    @IBOutlet var rateUserView: UIView!
    
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var rating: CosmosView!
    
    @IBOutlet var profileRating: CosmosView!
    
    var effect:UIVisualEffect!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    var ID : String = ""
    var ref: DatabaseReference!
    
   @IBOutlet weak var userImage: UIImageView!
    
    //sidemenu
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var menu: UIView!
    
    
    //table cell
    
    @IBOutlet weak var tableView: UITableView!
    
    var items:[Item] = []
    
    @IBOutlet weak var yourItems: UILabel!
    
    @IBOutlet weak var ifempty: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (ID == ""){
            if (Auth.auth().currentUser?.uid==nil){
                print("no user yet")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
                self.present(vc!, animated: true, completion: nil)
            }else{
                ID=(Auth.auth().currentUser?.uid)!
                // self.logoutSH.isHidden = false
            }
        }else {
            if (ID !=  Auth.auth().currentUser?.uid){
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
                print ("visitor")
                self.menu.isHidden=true
            }
        }
        
        ref = Database.database().reference()
        
        
        if tableView.visibleCells.isEmpty{
            //tableview is not data
            print("can not find data")
            ifempty.text="You Don't Have Any Items "
        }else{
            //do somethings
            
        }
        
        //Design
        yourItems.layer.cornerRadius=14
        yourItems.layer.masksToBounds = true
        
        yourItems.layer.shadowColor = UIColor.black.cgColor
        yourItems.layer.shadowOpacity = 2
        yourItems.layer.shadowOffset = CGSize.zero
        yourItems.layer.shadowRadius = 10
        tableView.tableFooterView = UIView()
        
        
        self.tableView.contentInset = UIEdgeInsets(top: 40,left: 0,bottom: 0,right: 0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        
        //sidemenu
        setShadow()
        //profile image -> circle
        
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        self.userImage.clipsToBounds = true
        self.userImage.layer.borderWidth = 3.0
        self.userImage.layer.borderColor = UIColor.white.cgColor

        self.ref!.child("Users/\(ID)").observe(.value , with: {(snapshot) in
            if (snapshot.value as? [String:Any]) != nil {
                //declare
                var first:String = " "
                var last:String = " "
                var img:String = ""
                var rateVal:String = "0"
                var rateCount:String = "0"
                
                //retrieve
                if ((snapshot.childSnapshot(forPath: "FirstName").exists()) == true)
                { first = snapshot.childSnapshot(forPath: "FirstName").value as! String }
                if ((snapshot.childSnapshot(forPath: "LastName").exists()) == true)
                { last = snapshot.childSnapshot(forPath: "LastName").value as! String }
                if ((snapshot.childSnapshot(forPath: "ProfilePic").exists()) == true)
                { img = snapshot.childSnapshot(forPath: "ProfilePic").value as! String }
                if ((snapshot.childSnapshot(forPath: "RateValue").exists()) == true)
                { rateVal = snapshot.childSnapshot(forPath: "RateValue").value as! String }
                if ((snapshot.childSnapshot(forPath: "RateCounter").exists()) == true)
                { rateCount = snapshot.childSnapshot(forPath: "RateCounter").value as! String }
                
                //set
                self.profileUser.text = "\(first) \(last)"
                if(img != "")
                { self.userImage.sd_setImage(with: URL(string: img)) }
                
                self.profileRating.text = "("+rateCount+")"
                if let ratVal = Double(rateVal){
                    self.profileRating.rating = ratVal
                }else{
                    self.profileRating.rating = 0
                }
            }
        })
        
        rateUserView.layer.cornerRadius = 5
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        rateButton.layer.cornerRadius = 5
        
        rateUserView.tag=99
        rateButton.tag=99
        rating.tag=99
        
         if (Auth.auth().currentUser?.uid != nil){
        if(!(self.ID == (Auth.auth().currentUser?.uid)!)){
            
        User.isUserRated(userId: self.ID){
            (success) -> Void in
            if(!success){
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
        }
            
        }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.ref!.child("Users/\(ID)").observe(.value , with: {(snapshot) in
            if (snapshot.value as? [String:Any]) != nil {
                //declare
                var first:String = " "
                var last:String = " "
                var img:String = ""
                
                //retrieve
                if ((snapshot.childSnapshot(forPath: "FirstName").exists()) == true)
                { first = snapshot.childSnapshot(forPath: "FirstName").value as! String }
                if ((snapshot.childSnapshot(forPath: "LastName").exists()) == true)
                { last = snapshot.childSnapshot(forPath: "LastName").value as! String }
                if ((snapshot.childSnapshot(forPath: "ProfilePic").exists()) == true)
                { img = snapshot.childSnapshot(forPath: "ProfilePic").value as! String }
                
                
                
                //set
                self.profileUser.text = "\(first) \(last)"
                if(img != "")
                { self.userImage.sd_setImage(with: URL(string: img)) }
            }
        })
        loadItems()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateIn() {
        self.view.addSubview(rateUserView)
        rateUserView.center = self.view.center
        
        rateUserView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        rateUserView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.rateUserView.alpha = 1
            self.rateUserView.transform = CGAffineTransform.identity
        }
        
    }
 
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.rateUserView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.rateUserView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.rateUserView.removeFromSuperview()
        }
    }
    
    
    @IBAction func ShowRatingView(_ sender: Any) {
        
        self.rateUserView.isHidden = false
        animateIn()
    }
    
    
    @IBAction func addRating(_ sender: Any) {
        
        let rateValue = rating.rating
        
        print("The rating: ")
        print(rateValue)
        
        User.rateUser(userId: self.ID, rating: rateValue)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
        animateOut()
        
    }
    
    func setShadow(){
        menu.layer.shadowOpacity=0.5
        menu.layer.shadowRadius=6
    }
    
    @IBAction func showMenu(_ sender: Any) {
        if(leading.constant == -205){
            leading.constant = 0
            UIView.animate(withDuration: 0.3, animations:{ self.view.layoutIfNeeded()})
        }
        else{
            leading.constant = -205
            UIView.animate(withDuration: 0.3, animations:{ self.view.layoutIfNeeded()})
        }
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView:UITableView!, numberOfRowsInSection section:Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:itemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! itemTableViewCell
        cell.setItem(item: items[indexPath.row])
        return cell
    }
    
    /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     performSegue(withIdentifier: "viewSitem", sender: self.tableView.cellForRow(at: indexPath))
     }*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewSitem", sender: items[indexPath.row])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewSitem"
        {
            let linkingPage = segue.destination as! ItemDViewController
            // let cell = sender as! itemTableViewCell
            // linkingPage.itemDetail=cell.info
            if let item=sender as? Item {
                linkingPage.itemDetail=item}
            
        }
    }
    
    
    func loadItems(){
        self.items.removeAll()
        ref.child("Items").queryOrdered(byChild: "seller").queryEqual(toValue: self.ID).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary{
                
                let itemcell:Item=Item(ItemKey: snapshot.key, name: dictionary["name"] as! String, description: dictionary["description"] as! String,price:dictionary["price"] as! String ,  imageURL: dictionary["url"] as! String, category:dictionary["category"] as! String, location:dictionary["location"] as! String , sellerUID:dictionary["seller"] as! String)
                self.items.append(itemcell)
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()

            }})
    }//load item
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        
        if let touch = touches.first {
            if(touch.view?.tag != 99){
                //Call your dismiss method
                animateOut()
                
            }
        }
  
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
