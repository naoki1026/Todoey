//
//  Item.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/12.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategories = LinkingObjects(fromType: Category.self, property: "items")
}
