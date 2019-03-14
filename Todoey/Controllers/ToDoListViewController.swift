//
//  ViewController.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/10.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import RealmSwift
//import CoreData
//import SwipeCellKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    //var todoItems = [Item]()
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        
        didSet {
        loadItems()
            
        }
    }
    
    //ユーザーデフォルト
//    let defaults = UserDefaults.standard
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //もしかしたらこれが影響してエラーになるかも？
    //let request : NSFetchRequest<Item> = Item.fetchRequest()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

        //print(dataFilePath)
       
        //loadItems(with: request)
        //アプリが立ち上がるたびにユーザーデフォルトからキー値を基にして取り出す
       //必要がある
        
        //if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
        //todoItems = items
       //}
        tableView.separatorStyle = .none
        
        
    }
    
    //viewDidLoatの後に処理される
    override func viewWillAppear(_ animated: Bool) {
        
           title = selectedCategory!.name
        
        guard let colorHex = selectedCategory?.color else  { fatalError("Navigation controller does not exist")}
        
        updateNavBar(withHexCode: colorHex)

//            //もしもnavigationController?.navigationBarがnilだった場合にエラーを表示する
//            guard let navBar = navigationController?.navigationBar else {fatalError("Navigaton controller does not exist.")}
        
                
            }
    
    //ここで色が戻る
    override func viewWillDisappear(_ animated: Bool) {
        
        //guard let originalColor = UIColor(hexString: "1D9BF6") else
            //{fatalError()}
        
        updateNavBar(withHexCode: "1D9BF6")
//        navigationController?.navigationBar.barTintColor = originalColor
//        navigationController?.navigationBar.tintColor = FlatWhite()
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
        
    }
    
    func updateNavBar(withHexCode colorHexCode: String){
        
        //もしもnavigationController?.navigationBarがnilだった場合にエラーを表示する
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigaton controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode)  else { fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true) ]
        searchBar.barTintColor = navBarColor
        
    }
    
    //Mart - TableView Datasource Methods
    //セクションの中のセルの数で、配列の分だけセルを返すためresultArray.countを返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    //ここがセクションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    // セルを生成して返却するメソッドで、セルの数だけ呼び出される。
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //dequeueReusableCellを呼び出すことで、セルが再び表示された際に画面上からセルに対して処理した内容が反映された上で表示される
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        
        //オーバーライドを使用して、スーパークラスで定義されているプロパティやメソッドをサブクラスで再定義している
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if  let item = todoItems?[indexPath.row]  {
            
            //セルの数だけ配列を出してあげる必要がある
            //ここでタイトルを取り出してあげる
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                
                //テキストの色がセルの色と逆になる
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            //CGFloatでそれぞれを囲んであげないといけない
            print("version 1 :  \(CGFloat(indexPath.row / todoItems!.count))")
            print("version 2 :  \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
            
            
            
            //Tenary operator
            //value = condition ? valueTrue : valueFalse
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            //        if item.done == true {
            //
            //            //チェックマークをつける
            //            cell.accessoryType = .checkmark
            //
            //        } else {
            //
            //            //チェックマークを外す
            //            cell.accessoryType = .none
            //
            //        }
            
            //ここでセルを返してあげる
            
        } else {
            
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
        
    }
    
     //TableViewDelegateMethods
    //選択しているセルの番号を表示させることができる
    //セルが選択された場合に処理したい内容をこの関数の中に記述していく
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
            try realm.write {
                
                //realm.delete(item)
                item.done = !item.done
            }
            } catch {
                
            print("Error saving done status, \(error)")
            
                
            }
            
        }
        
        tableView.reloadData()
        
        //print(todoItems[indexPath.row])
        
        //todoItemsの方から先に取り除いてしまうと、contextから削除されなくなるため、順番に注意する
        //この２つのコードを追加した状態だと、タップした場合に削除するという動きになる
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(at: indexPath.row)
        
        //この１行で、チェックがついていれば外して、チェックがついていなければつけることを表している
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItems()
        
        
        //クリックした時にチェックマークをつけることができる
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //itemクラスを継承しており、チェックマークがついているかどうか判定している
 
        //チェックがある場合はチェックを外し、チェックがない場合はチェックをつけるif文
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //何か変更した際は再度読み込んであげる必要がある
        //saveItemsの中でreloadDataを行うため
        //tableView.reloadData()
        
        //選択された際のグレーをすぐに白に戻すことができる
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        //ここで変数を定義しておくことによって、alertTextVCieldを
       //この関数全体で使用することができるようになる
        var textField = UITextField()
        
        //表示する文章の名前
        let alert = UIAlertController(title: "Add New Todoy", message: "", preferredStyle: .alert)
        
        //処理を実行する際のボタン名
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("success")
            
            //クロージャーの中に入っているため、selfをつける必要がある
            //let newItem = Item(context: self.context)
            
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                    
                    let newItem = Item()
                    newItem.title = textField.text!
                    
                    //抽出条件を追加する場合
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    
                }
                } catch {
                    print("Error saving new items, \(error)")
                    
                }
            }
            
            self.tableView.reloadData()
            
            //newItem.done = false
            //newItem.parentCategory = self.selectedCategory
            //self.todoItems.append(newItem)
            
            //self.todoItems.append(newItem)
            
            
            //self.saveItems()
            
            //UserDefaultsに追加する
            //self.defaults.set(self.todoItems, forKey: "ToDoListArray")
            
        }
        
        //ポップアップに入力欄を追加して、その入力欄の説明書きを
       //定義することができる
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        //実行する
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //データを保存している
//    func saveItems() {
//
//        //let encoder = PropertyListEncoder()
//
//        do {
//
//
//            try context.save()
//
////
////            let data = try encoder.encode(todoItems)
////            try data.write(to: dataFilePath!)
//
//        } catch {
//            print("Error saving context \(error)")
////            print("Error encoding item array, \(error)")
//
//        }
//
//        //テーブルに反映するためにはし再度読み込み直す必要がある
//        self.tableView.reloadData()
//
//    }
    
    //保存されたデータを取り出している
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
    //func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //parentCategoryが同じセルが呼び出されている
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory!.name!)
//
//        if let additionalPredicate = predicate{
//
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//
//        } else {
//
//            request.predicate =  categoryPredicate
//        }
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
////
////        request.predicate = compoundPredicate
//
//        //NSFetchRequest<Item>と特定してあげないとエラーになってしまう
//        //let request: NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//
//        todoItems = try context.fetch(request)
//
//        } catch {
//
//        print("Error  fetching data from context")
//
//    }

        tableView.reloadData()

  }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                
                try self.realm.write {
                    
                    self.realm.delete(item)}
                
            } catch {
                
                print("Error deleting category, \(error)")
                
            }
        }
    }
    
}



//Mark: - Search bar methods
//extensionを使用することで、今あるクラスを拡張して使うことができる
//クラスの外側に記述する
//検索バーについて定義している
extension ToDoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd]  %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)

//        do {
//            todoItems = try context.fetch(request)
//        } catch {
//            print("Error  fetching data from context")
//
//        }

        //これを入れてあげないとクラッシュしてしまう！！！！
        //tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //非同期処理について
            //キーボードを非表示にすることができる
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }

        }

    }


}

