//
//  Category.swift
//  Todoet
//
//  Created by Thien Vu Le on Jun/20/18.
//  Copyright © 2018 Thien Vu Le. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColor: String = ""
    
    let items = List<Item>()
    
}
