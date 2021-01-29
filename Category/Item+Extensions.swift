//
//  Item+Extensions.swift
//  Category
//
//  Created by Dave Kondris on 29/01/21.
//

import Foundation
import CoreData

extension Item {
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Item> {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        request.predicate = predicate
        return request
    }
}
