//
//  item.swift
//  Todoey
//
//  Created by Naoki Arakawa on 2019/03/10.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import Foundation

//このcodableの中にはencodableとdecodableの意味が含まれている
class Item : Codable {
    var title: String = ""
    var done: Bool = false
}
