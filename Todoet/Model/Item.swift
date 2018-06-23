//
//  Item.swift
//  Todoet
//
//  Created by Thien Vu Le on Jun/20/18.
//  Copyright © 2018 Thien Vu Le. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    @objc dynamic var hexColor: String = ""
    
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
