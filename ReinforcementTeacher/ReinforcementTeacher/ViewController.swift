//
//  ViewController.swift
//  ReinforcementTeacher
//
//  Created by Roland Meertens on 23/10/14.
//  Copyright (c) 2014 astrant. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext!) as User
        user.name = "een naam"
        user.ipaddress = "de ip address"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

