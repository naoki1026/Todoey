//
//  Category.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/12.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items =  List<Item>()
}
