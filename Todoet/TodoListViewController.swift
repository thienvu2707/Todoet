//
//  ViewController.swift
//  Todoet
//
//  Created by Thien Vu Le on Jun/16/18.
//  Copyright © 2018 Thien Vu Le. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var itemArray = ["Find something", "Buy chickens", "Washing dishes"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new item to the list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldOfAlert = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Todo", style: .default) { (alertAction) in
            //action will happen after user click button add todo in alert UI
            if textFieldOfAlert.text?.isEmpty == false {
                self.itemArray.append(textFieldOfAlert.text!)
                self.tableView.reloadData()
            } else {
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Todo item"
            textFieldOfAlert = alertTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

