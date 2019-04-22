//
//  SearchViewController.swift
//  Real Madrid
//
//  Created by Georgy Jose on 07/04/2019.
//  Copyright © 2019 Georgy Jose. All rights reserved.
//

import UIKit
import CoreData


class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
   
    //Setting Core data objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var playerManagedObjects : Player! = nil// For retrieveing the normal coredata
    var searchPlayerManagedObjects : Player! = nil // seperate managed objects for the data been retireved after searching
    
    //Setting the searchbar
    let searchController = UISearchController(searchResultsController: nil)
   
   //Setting the NSFetchRequestController
    var frcSearch : NSFetchedResultsController<NSFetchRequestResult>! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
   
    var searchVal : String = "" // Search Text value obtained from the search bar
    
    //Outlets and actions
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Enter the name of the players"
        searchController.searchBar.tintColor = UIColor.blue
        searchController.searchBar.barTintColor = UIColor.blue
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["Name", "Nationality", "Position"]
        searchController.searchBar.delegate = self
        
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc .delegate = self
        do{
            try frc .performFetch()
        }
        catch{
            print(" Code DATA CANNOT FETCH CONTENT!")
        }
        
        tableView.delegate = self
       
       // tableView.reloadData()
        
        //dataTransfer()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // TO set the total number of retreived columns
        if isSearching(){
            return frcSearch.sections![section].numberOfObjects
        }
        else{
            return frc.sections![section].numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isSearching(){
            print("SearchPlayerManagedObjects")
            searchPlayerManagedObjects = frcSearch.object(at: indexPath) as? Player
            
            cell.textLabel!.text = searchPlayerManagedObjects.name
            cell.detailTextLabel?.text = searchPlayerManagedObjects.nationality
            
        }
        else{
            playerManagedObjects = frc.object(at: indexPath) as? Player
            cell.textLabel!.text = playerManagedObjects.name
            cell.detailTextLabel?.text = playerManagedObjects.nationality
        }

        return cell

    }
    func updateSearchResults(for searchController: UISearchController) {
       //Setting the search text to filter the content
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContent(searchController.searchBar.text!, scope: scope)
    }
    func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContent(_ searchText : String, scope : String ){
        searchVal = searchText
        let searchRequest = makeRequestFilter(filter: true, scope: scope)
        
        frcSearch  = NSFetchedResultsController(fetchRequest: searchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frcSearch .delegate = self
        do{
            try frcSearch.performFetch()
        }
        catch{
            print(" Code DATA CANNOT FETCH CONTENT!")
        }
        tableView.reloadData()
        
    }
    
    func isSearching() -> Bool{
        let searchBarScope = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func makeRequestFilter(filter : Bool, scope : String) -> NSFetchRequest<NSFetchRequestResult>{
        //Searching request and setting up the predicate and sorter
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        let predicate : NSPredicate
        if(scope == "Name")
        {
            predicate = NSPredicate(format: "name contains[c] %@" , searchVal)
        }
        else if( scope == "Nationality"){
            predicate = NSPredicate(format: "nationality contains[c] %@", searchVal)
        }
        else {
            predicate = NSPredicate(format: "position contains[c] %@", searchVal)
        }
        request.predicate = predicate
        return request
    }
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult>{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        return request
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
