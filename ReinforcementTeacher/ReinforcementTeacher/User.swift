//
//  User.swift
//  ReinforcementTeacher
//
//  Created by Stef Janssen on 23/10/14.
//  Copyright (c) 2014 astrant. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var username: String
    @NSManaged var ipaddress: String

}
