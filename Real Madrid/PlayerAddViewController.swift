//
//  PlayerAddViewController.swift
//  Real Madrid
//
//  Created by Georgy Jose on 06/04/2019.
//  Copyright © 2019 Georgy Jose. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class PlayerAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //Setting up the core data objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity : NSEntityDescription! = nil
    var playerManagedObjects : Player! = nil
    
    //Outlets and Actions
    @IBOutlet weak var addOrUpdate: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var imageNameText: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
      override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Add or Update Player"
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .sound , .badge], completionHandler: {didAllow, error in})
        
        if(playerManagedObjects != nil){
            addOrUpdate.text = "Update Player"
            nameTextField.text = playerManagedObjects.name
            positionTextField.text = playerManagedObjects.position
            nationalityTextField.text = playerManagedObjects.nationality
            imageNameText.text = playerManagedObjects.image
            let imageVal = imageNameText.text as! String
            let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("realImages")
            let path = "\(documentDirectory)/\(imageVal)"
            imageView.image = UIImage(named: path)
          
        }
        else{
            addOrUpdate.text = "Add Player"
        }

        // Do any additional setup after loading the view.
    }
    func addPlayer(){
        playerManagedObjects = Player(context: context)
        playerManagedObjects.name = nameTextField.text
        playerManagedObjects.position = positionTextField.text
        playerManagedObjects.nationality = nationalityTextField.text
        playerManagedObjects.image = imageNameText.text
        
        do{
            try context.save()
        }
        catch{
            print("Core data cannot be saved")
        }
        let content = UNMutableNotificationContent()
        content.title = "Added new Player"
        content.body = nameTextField.text! + " has been added to the crew"
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "playerAdded", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func updatePlayer(){
        playerManagedObjects.name = nameTextField.text
        playerManagedObjects.position = positionTextField.text
        playerManagedObjects.nationality = nationalityTextField.text
        playerManagedObjects.image = imageNameText.text
        
        do{
            try context.save()
        }
        catch{
            print("Core data cannot be saved")
        }
        
        
    }
   
    @IBAction func addOrUpdateButton(_ sender: Any) {
        if(playerManagedObjects != nil){
            updatePlayer()
            navigationController?.popViewController(animated: true)
          
        }
        else{
            addPlayer()
            navigationController?.popViewController(animated: true)
            
        }
        
       
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        let imageName = CFURLCopyLastPathComponent(imageURL)
      
        
        imageNameText.text = imageName as! String
        imageView.image = image
        
        
        dismiss(animated: true, completion: nil)
        
        saveImage(image: image, imageName: imageName as! String )
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    var imagePicker = UIImagePickerController()
    @IBAction func pickImageButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .savedPhotosAlbum
            
            present(imagePicker,animated: true, completion: nil)
            
        }
    }
 
    func saveImage(image : UIImage, imageName : String){
        //Saving the image to the file directory
        
        let fileManager = FileManager.default
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("realImages")
        
        if !fileManager.fileExists(atPath: path){
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = NSURL(string: path)
        
        let imagePath = url!.appendingPathComponent(imageName)
        
        let urlString = imagePath!.absoluteString
        
        let imageData = image.jpegData(compressionQuality: 0.5)
       
     
        fileManager.createFile(atPath: urlString, contents: imageData, attributes: nil)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
