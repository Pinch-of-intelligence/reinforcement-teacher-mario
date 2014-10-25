//
//  LoginViewController.swift
//  NESController
//
//  Created by Stef Janssen on 17/10/14.
//  Copyright (c) 2014 Stef Janssen. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    var user :User?

    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest(entityName: "User")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [User] {
            if fetchResults.count == 0 {
                user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext!) as User
                user!.ipaddress = "192.168.2.25:8001"
                managedObjectContext!.save(nil)
            }
            else {
                user = fetchResults[0]
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue"{
            user!.username = usernameField.text
            managedObjectContext!.save(nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
