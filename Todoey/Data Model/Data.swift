//
//  Data.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/12.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    
    //objective-Cのランタイムを使用するために、dynamicのキーワードが必要となっている
    //ランタイムは開発の機能を省き、実効の機能のみを取り出したプログラムのこと
    //ovjective-Cのメソッド（機能）をSwiftで使うためにはdynamicキーワードが必要になっている
    //この２点のプロパティを用いることで監視している
    //た立ち上がるたびにこの２つのデータがRealmに登録される
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
