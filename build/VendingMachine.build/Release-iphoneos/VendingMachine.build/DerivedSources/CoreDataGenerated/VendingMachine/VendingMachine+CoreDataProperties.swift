//
//  VendingMachine+CoreDataProperties.swift
//  
//
//  Created by Tuyen Le on 2/26/20.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension VendingMachine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VendingMachine> {
        return NSFetchRequest<VendingMachine>(entityName: "VendingMachine")
    }

    @NSManaged public var amount: Double
    @NSManaged public var candy: Int64
    @NSManaged public var chip: Int64
    @NSManaged public var cola: Int64

}
