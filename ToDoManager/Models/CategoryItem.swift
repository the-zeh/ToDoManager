//
//  Category.swift
//  ToDoManager
//
//  Created by Zehra Saglam on 11/06/2023.
//

import Foundation
import RealmSwift

class CategoryItem: Object {
    @objc dynamic var title: String = ""
    var items = List<Item>()
}
