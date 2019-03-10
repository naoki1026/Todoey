//
//  ViewController.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/10.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //セルの数だけ配列を出してあげる必要がある
        cell.textLabel?.text = itemArray[indexPath.row]
        
        //ここでセルを返してあげる
        return cell
        
    }
    
     //TableViewDelegateMethods
    //選択しているセルの番号を表示させることができる
    //セルが選択された場合に処理したい内容をこの関数の中に記述していく
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //クリックした時にチェックマークをつけることができる
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //チェックがある場合はチェックを外し、チェックがない場合はチェックをつけるif文
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //選択された際のグレーをすぐに白に戻すことができる
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    
    }

