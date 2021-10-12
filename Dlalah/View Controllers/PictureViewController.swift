//
//  PictureViewController.swift
//  Dlalah
//
//  Created by Hend Alzahrani on 11/2/17.
//  Copyright © 2017 Lama Alashed. All rights reserved.
//

import UIKit
import Firebase

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var photoLibraryButton: UIButton!
    //test test
    
    @IBOutlet weak var deleteOutlet: UIButton!
    @IBOutlet weak var nextOutlet: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var libraryView: UIView!
    var picker:UIImagePickerController?=UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (imageView.image==nil){
            deleteOutlet.isHidden=true
            
        }else{
              deleteOutlet.isHidden=false
        }
        
        
        if (Auth.auth().currentUser?.uid==nil){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(vc!, animated: true, completion: nil)
        }
        
        picker?.delegate=self
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor(displayP3Red: 25/255, green: 149/255, blue: 173/255, alpha: 1.0)]
        
        cameraButton.setImage(UIImage(named: "camera.png"), for: .normal)
        photoLibraryButton.setImage(UIImage(named: "library.png"), for: .normal)
        
        // Do any additional setup after loading the view.
        design()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (imageView.image==nil){
            deleteOutlet.isHidden=true
            
        }else{
            deleteOutlet.isHidden=false
        }
        
    }
    
    func design(){
        let size:CGFloat = 55
        cameraView.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        cameraView.layer.cornerRadius = size / 2
        libraryView.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        libraryView.layer.cornerRadius = size / 2
       nextOutlet.layer.cornerRadius=5
 
    }
    @IBAction func deleteImage(_ sender: Any) {
        imageView.image = nil
        deleteOutlet.isHidden=true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TakeFromCamera(_ sender: Any) {
    openCamera()
    }
    
    @IBAction func TakeFromLibrary(_ sender: Any) {
        openGallary()
    }
    
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SellViewController
        vc.itemImage = imageView.image as! UIImage
    }
  
    @IBAction func goToSellDetails(_ sender: Any) {
        
        if (imageView.image == nil)  {
            let alert = UIAlertController(title: "Error", message: "Please upload a picture first", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.performSegue(withIdentifier: "goToSellSegue", sender: self)
        }

    }
    
}
