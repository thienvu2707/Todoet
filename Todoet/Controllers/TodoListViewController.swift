//
//  ViewController.swift
//  Todoet
//
//  Created by Thien Vu Le on Jun/16/18.
//  Copyright © 2018 Thien Vu Le. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchTodoItem: UISearchBar!
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var toDoItems : Results<Item>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        guard let hexColor = selectedCategory?.hexColor else {fatalError()}
        updateNavBar(withHexCode: hexColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "0096FF")
    }

    //MARK: Update Nav Bar
    func updateNavBar(withHexCode hexCodeColor: String) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation bar does not exist")
        }
        
        guard let navBarColor = UIColor(hexString: hexCodeColor) else { fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchTodoItem.barTintColor = navBarColor
    }
    
    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
//            cell.backgroundColor = UIColor(hexString: (toDoItems?[indexPath.row].hexColor)!)
            
            //check if cell is selected or not
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item added yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    // MARK: TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating Item \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new item to the list
    
    //Add button what to do in it
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldOfAlert = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Todo", style: .default) { (alertAction) in
            //action will happen after user click button add todo in alert UI
            if textFieldOfAlert.text?.isEmpty == false {
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textFieldOfAlert.text!
                            newItem.dateCreated = Date()
    
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving Item \(error)")
                    }
                }
                
                self.tableView.reloadData()
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
    
    
    // func fetching data from database
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    //func deleting data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = toDoItems?[indexPath.row]{
            do {
                try realm.write {
                realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
}

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

