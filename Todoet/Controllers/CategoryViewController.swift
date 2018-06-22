//
//  CategoryViewController.swift
//  Todoet
//
//  Created by Thien Vu Le on Jun/18/18.
//  Copyright © 2018 Thien Vu Le. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    
    
    let realm = try! Realm()

    //create object access to attribute of database
    var categories : Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.rowHeight = 80
        

    }
    
    // MARK: TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create variable for cell with identifiers and path
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //create variable each cell in array
        let categoryArray = self.categories?[indexPath.row].name ?? "Category not added yet"
        
        //show cell on tableView
        cell.textLabel?.text = categoryArray
//        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: Data Manupulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Save category error \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryFordeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryFordeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }

    }
    
    
    //MARK: Add New catagory
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //create alertTextField
        var textField = UITextField()
        
        //create an alert by using UIAlertController
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)

        //create an alertAction to do in alert popups
        let alertAction = UIAlertAction(title: "Add Category", style: .default) {
            (alertAction) in
            //check if textField is empty or not
            if textField.text?.isEmpty == false {
                
                //create variable of new category that has attribute of database
                let newCategory = Category()
                
                newCategory.name = textField.text!
                
                self.save(category: newCategory)
            } else {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        // create alert with a text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Swipe Cell Delegate Methods
