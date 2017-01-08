//
//  Message+CoreDataProperties.swift
//  fbMessanger
//
//  Created by Mohit Kumar on 28/12/16.
//  Copyright © 2016 Mohit Kumar. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var isSender: Bool
    @NSManaged public var friend: Friend?

}
