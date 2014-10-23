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


    @IBOutlet weak var userNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("loaded login view")
        user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext!) as? User
        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue"{
            if user?.ipaddress == nil{
                user!.ipaddress = "192.168.2.25:8001"
            }
            user!.username = userNameField.text
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
