//
//  EditItemViewController.swift
//  Dlalah
//
//  Created by Hend Alzahrani on 11/26/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {

    var item:Item?
    
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var category: UIPickerView!
    @IBOutlet weak var itemDescription: UITextView!
    
    let tags = ["Electronics", "Furniture", "Computers", "Cars", "Books", "Clothing","Food"]
    var cat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemName.text = item?.name
        itemDescription.text = item?.description
        price.text = item?.price
        location.text = item?.location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cat=tags[row]
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveEdits(_ sender: Any) {
        
        if(itemName.text == "" || price.text == "" || itemDescription.text == "" || location.text == ""){
            let alertController = UIAlertController(title: "Empty Fields", message: "Please fill all the fields.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else{
        
        let values = ["name": itemName.text!, "description": itemDescription.text!, "price": price.text!, "category":self.cat]
        
        Item.updateItem(itemID: (item?.ItemKey)!, withValues: values)
        
        let message = " Updated Successfully "
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        // duration in seconds
        let duration: Double = 1
            
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }
            
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // fire when someone click on return
        self.view.endEditing(true)
        return true
    }

}
