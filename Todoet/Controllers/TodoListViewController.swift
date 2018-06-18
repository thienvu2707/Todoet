//
//  ViewController.swift
//  Todoet
//
//  Created by Thien Vu Le on Jun/16/18.
//  Copyright © 2018 Thien Vu Le. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let itemInArray = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemInArray.title
        
        //check if cell is selected or not
        cell.accessoryType = itemInArray.done == true ? .checkmark : .none
        
//        if itemInArray.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        //reverse true false when user click on each cell
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
//        print(itemArray[indexPath.row])
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
    }
    
    // MARK: Add new item to the list
    
    //Add button what to do in it
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldOfAlert = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Todo", style: .default) { (alertAction) in
            //action will happen after user click button add todo in alert UI
            if textFieldOfAlert.text?.isEmpty == false {
                
                let newItem = Item(context: self.context)
                
                newItem.title = textFieldOfAlert.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                
                self.saveItems()
            } else {
                
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        alert.addTextField {
            
            (alertTextField) in
            alertTextField.placeholder = "Create new Todo item"
            textFieldOfAlert = alertTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Model manupulation method
    
    /**
     func to save data in local database
     */
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // func fetching data from database
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //request database on selected category
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)

        if predicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetch request \(error)")
        }
        tableView.reloadData()
    }
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //request to fetch data from database to search
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //search each row in database column title
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Sort data after searching
        let sortData = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortData]
        
        //do fetch data from database
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

