//
//  Item.swift
//  Mr. Lister
//
//  Created by Adam Hu on 2/15/20.
//  Copyright © 2020 Adam Hu. All rights reserved.
//

import Foundation
import CoreData

public class Item:NSManagedObject, Identifiable{
    @NSManaged public var name:String
    @NSManaged var index: Int
    @NSManaged public var notes:String
}

