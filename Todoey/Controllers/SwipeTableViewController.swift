//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/13.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルの高さを定義
        tableView.rowHeight = 80.0

        
    }
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation:
        
        SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        //アイコンの下に表示する文字を定義
        let deleteAction = SwipeAction(style: .destructive, title: "削除") { action, indexPath in
            
            //この中に削除の際に行いたい処理内容を記述する
            print("Delete Cell")
            self.updateModel(at: indexPath)
            
        }
        
        // customize the action appearance
        //ここで画像が必要であるということがわかる
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    func updateModel(at indexPath: IndexPath) {
        
        //Update our data model
        
    }
    

}
