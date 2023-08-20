//
//  Item.swift
//  ToDoManager
//
//  Created by Zehra Saglam on 11/06/2023.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    var cat = LinkingObjects(fromType: CategoryItem.self, property: "items") //property is the name of relationship that we created in the categoryItem
}
