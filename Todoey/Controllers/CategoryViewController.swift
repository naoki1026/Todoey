//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/12.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

//-Realmで変更
import RealmSwift
import SwipeCellKit
import ChameleonFramework


//SwipeTableViewControllerを継承している
class CategoryViewController: SwipeTableViewController {
   
    //-Realmで変更
    //イニシャライズしている
    let realm = try! Realm()
    
    //-Realmで変更
    //var categories = [Category]()
    //Result型と定義している
    //?はオプショナルで、安全のためにつけている
    var categories: Results<Category>?
    
    //-Realmで不要
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let request : NSFetchRequest<Category> = Category.fetchRequest()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
        
        //これでテーブルの枠線を非表示にすることができる
        tableView.separatorStyle = .none
        
        
    }
    
    //Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //もしnilだった場合に１を返す
        return categories?.count ?? 1
        
    }
    
    override func   numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        //        cell.delegate = self
        //        return cell
        //    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //このCategoryCellの部分を変更してあげないとクラッシュしてしまう
        //as!はダウンキャスト
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        //オーバーライドを使用して、スーパークラスで定義されているプロパティやメソッドをサブクラスで再定義している
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//
        if let category = categories?[indexPath.row]{
            
            //categoriesの後ろの？の意味は、categoriesがnilではない場合にそれ以降を返すという意味らしい
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
                
                //categoriesがnilだった場合に、3089FEの色を定義する
                //cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "3089FE")
                //cell.backgroundColor = UIColor.randomFlat
               cell.backgroundColor = UIColor(hexString: category.color)
             cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
    }
        
        //cell.delegate = self
        
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
            
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
    //データを保存している
    func save(category: Category) {
        
        do {
            
            try realm.write {realm.add(category)}
  
        } catch {
            
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //保存されたデータを取り出している
    //-Realmで変更
    func loadCategories() {
        
       //この１行でrealmに保存されている全てのデータを取り出すことができる
      //categoriesのプロパティの中に、Categoryに保有しているデータを全て取ってくる
       categories = realm.objects(Category.self)
        
//    let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//
//            categories = try context.fetch(request)
//
//        } catch {
//
//            print("Error  fetching data from context")
//
//        }

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
    if let categoryForDeletion = categories?[indexPath.row] {
        
        do {
            
        try self.realm.write {
            
        self.realm.delete(categoryForDeletion) }
            
        } catch {
            
        print("Error deleting category, \(error)")
            
           }
        }
     }

    //Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("success")
            
            //-Realmで追加
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            //-Realmで変更、自動的に追加されるため記述する必要はない
            //self.categories.append(newCategory)
            
            //-Realmで変更
            self.save(category: newCategory)
        
       }
        alert.addAction(action)
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
            
        }
        //実行する
        
        present(alert, animated: true, completion: nil)

}
    
    

}


