//
//  CategoryViewController.swift
//  Todoet
//
//  Created by Thien Vu Le on Jun/18/18.
//  Copyright © 2018 Thien Vu Le. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //create object access to attribute of database
    var categoryArray = [Category]()
    
    //create object access to AppDelegate to use CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create variable for cell with identifiers and path
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //create variable each cell in array
        let categoryArray = self.categoryArray[indexPath.row].categoryName
        
        //show cell on tableView
        cell.textLabel?.text = categoryArray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: Data Manupulation Methods
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Save category error \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray =  try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        
        tableView.reloadData()
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
                let newCategory = Category(context: self.context)
                
                newCategory.categoryName = textField.text!
                
                //append new create category to array
                self.categoryArray.append(newCategory)
                
                self.saveCategory()
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
