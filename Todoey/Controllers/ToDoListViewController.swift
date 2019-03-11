//
//  ViewController.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/10.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //ユーザーデフォルト
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(dataFilePath)
        
        loadItems()
        //アプリが立ち上がるたびにユーザーデフォルトからキー値を基にして取り出す
       //必要がある
        
        //if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
        //itemArray = items
       //}
    
    }
    

    //Mart - TableView Datasource Methods
    //セクションの中のセルの数で、配列の分だけセルを返すためresultArray.countを返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    //ここがセクションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルを生成して返却するメソッドで、セルの数だけ呼び出される。
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //dequeueReusableCellを呼び出すことで、セルが再び表示された際に画面上からセルに対して処理した内容が反映された上で表示される
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        //セルの数だけ配列を出してあげる必要がある
        //ここでタイトルを取り出してあげる
        cell.textLabel?.text = item.title
        
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
        return cell
        
    }
    
     //TableViewDelegateMethods
    //選択しているセルの番号を表示させることができる
    //セルが選択された場合に処理したい内容をこの関数の中に記述していく
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //この１行で、チェックがついていれば外して、チェックがついていなければつけることを表している
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        
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
            
            //print(textField.text!)
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
            
            //UserDefaultsに追加する
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            
            
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
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            
            print("Error encoding item array, \(error)")
            
        }
        
        //テーブルに反映するためにはし再度読み込み直す必要がある
        self.tableView.reloadData()
        
        
        
    }
    
    //保存されたデータを取り出している
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do{
            itemArray = try decoder.decode([Item].self, from: data)
        
            } catch {
                print("Error decoding item array, \(error)")
            }
     }
    
    }

}
