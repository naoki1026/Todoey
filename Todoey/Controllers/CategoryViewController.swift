//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/12.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<Category> = Category.fetchRequest()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
        
    }
    
    //Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    override func   numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //このCategoryCellの部分を変更してあげないとクラッシュしてしまう
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
        
    }
    
    
    //セルがタップされたとき
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: nil)
        //saveCategories()
        //tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories[indexPath.row]
            
        }
    }
    
    //データを保存している
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //保存されたデータを取り出している
    func loadCategories() {
        
        do {
            
            categories = try context.fetch(request)
            
        } catch {
            
            print("Error  fetching data from context")
            
        }
        
        tableView.reloadData()
    }

    //Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("success")
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveCategories()
        
       }
    
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
            
        }
        //実行する
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

}
    

}
