//
//  PlayerTableViewController.swift
//  Real Madrid
//
//  Created by Georgy Jose on 06/04/2019.
//  Copyright © 2019 Georgy Jose. All rights reserved.
//

import UIKit
import CoreData

class PlayerTableViewController: UITableViewController, XMLParserDelegate, NSFetchedResultsControllerDelegate {
    
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var playerManagedObjects : Player! = nil
    var enitity : NSEntityDescription! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    var playerInfo = [PlayerData]()
    
    var tagName = ""
    var playerName = ""
    var playerJersey = ""
    var playerPosition = ""
    var playerImage = ""
    var playerText = ""
    var playerUrl = ""
    var playerDob = ""
    var playerNationality = ""
    var playerHeight = ""
    var playerWeight = ""
    var playerPicture = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Real Madrid Players"
        
        if let path = Bundle.main.url(forResource: "players", withExtension: "xml"){
            if let parser = XMLParser(contentsOf: path){
                parser.delegate = self
                parser.parse()
            }
        }
        if playerManagedObjects == nil{
              //saveData()
        }
    
        
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do{
            try frc.performFetch()
        }
        catch{
            print(" Code DATA CANNOT FETCH CONTENT!")
        }
        
        
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        playerManagedObjects = frc.object(at: indexPath) as? Player
        
        // Configure the cell...
        cell.textLabel!.text = playerManagedObjects.name
        cell.detailTextLabel!.text = playerManagedObjects.position
        
        let imageVal = playerManagedObjects.image as! String
        let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("realImages")
        print("Inside Update")
        print(documentDirectory)
        
        let path = "\(documentDirectory)/\(imageVal)"
        print("Path")
        print(imageVal)
        print(path)
        cell.imageView!.image = UIImage(named: path)
      //  cell.imageView!.image = UIImage(named: playerManagedObjects.image!)

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            playerManagedObjects = frc.object(at: indexPath) as? Player
           /* let fileManager = FileManager.default
            
            let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("realImages")
            
            let url = NSURL(string: path)
            
            let imagePath = url!.appendingPathComponent(playerManagedObjects.image!)
            
            let urlString = imagePath!.absoluteString
            
            if fileManager.fileExists(atPath: path){
                try! fileManager.removeItem(atPath: urlString)
            }
            */
            context.delete(playerManagedObjects)
            // Delete the row from the data source
            
            do{
                try context.save()
            }
            catch{ print("Cannot save the core data")}
            
            do{
                try frc.performFetch()
                
            }
            catch{ print("Cannot fetch the core data")}
            
            tableView.reloadData()
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        if segue.identifier == "updateSegue"{
            let destination = segue.destination as! PlayerAddViewController
            
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            playerManagedObjects = frc.object(at: indexPath!) as? Player
          //  var title : String = "Update"
            
            destination.playerManagedObjects = playerManagedObjects
            destination.title = "Update Player"
        }
        
        if segue.identifier == "searchSegue"{
            let destination = segue.destination as! SearchViewController
            destination.playerInfo = playerInfo
           // destination.playerManagedObjects = playerManagedObjects
            
        }
        // Pass the selected object to the new view controller.
    }
 
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        tagName = elementName
        
        if(elementName == "player"){
            var playerName = ""
            var playerJersey = ""
            var playerPosition = ""
            var playerImage = ""
            var playerText = ""
            var playerUrl = ""
            var playerDob = ""
            var playerNationality = ""
            var playerHeight = ""
            var playerWeight = ""
            var playerPicture = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if data.count != 0{
            switch tagName
            {
            case "name" : playerName = data
            case "jersey" : playerJersey = data
            case "position": playerPosition = data
            case "image": playerImage = data
            case "text" : playerText = data
            case "url" : playerUrl = data
            case "dob" : playerDob = data
            case "nationality": playerNationality = data
            case "height": playerHeight = data
            case "weight" : playerWeight = data
            case "pic" : playerPicture = data
            default:break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "player"{
            
            var playerData = PlayerData()
            playerData.name = playerName
            playerData.jersey = playerJersey
            playerData.position = playerPosition
            playerData.image = playerImage
            playerData.text = playerText
            playerData.url = playerUrl
            playerData.dob = playerDob
            playerData.nationality = playerNationality
            playerData.height = playerHeight
            playerData.weight = playerWeight
            playerData.picture = playerPicture
            
            playerInfo.append(playerData)
        }
        
    }
    

    func saveData(){
       
        
        var counter : Int = 0
        while(counter < 4 ){//playerInfo.count
            playerManagedObjects = Player(context :context)
            playerManagedObjects.name = playerInfo[counter].name
            playerManagedObjects.jersey = playerInfo[counter].jersey
            playerManagedObjects.position = playerInfo[counter].position
            playerManagedObjects.image = playerInfo[counter].image
            playerManagedObjects.text = playerInfo[counter].text
            playerManagedObjects.url = playerInfo[counter].url
            playerManagedObjects.dob = playerInfo[counter].dob
            playerManagedObjects.nationality = playerInfo[counter].nationality
            playerManagedObjects.height = playerInfo[counter].height
            playerManagedObjects.weight = playerInfo[counter].weight
            playerManagedObjects.pic = playerInfo[counter].picture
            saveImage(imageName: playerManagedObjects.image!)
            
        
        do{
            try context.save()
        }
        catch {
            print(" CORE DATA DOES NOT SAVE!")
        }
        counter = counter + 1
        }
    }
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult>{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        
        let sorter = NSSortDescriptor(key: "position", ascending: true)
        request.sortDescriptors = [sorter]
        
        return request
    }
    func saveImage(imageName : String){
        
        let fileManager = FileManager.default
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("realImages")
        
        if !fileManager.fileExists(atPath: path){
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = NSURL(string: path)
        
        let imagePath = url!.appendingPathComponent(imageName)
        
        let urlString = imagePath!.absoluteString
        
        
        let image = UIImage(named: imageName)
        let imageData = image!.jpegData(compressionQuality: 0.5)
       
      
        fileManager.createFile(atPath: urlString, contents: imageData, attributes: nil)
        
        
    }
    
    
 
}
