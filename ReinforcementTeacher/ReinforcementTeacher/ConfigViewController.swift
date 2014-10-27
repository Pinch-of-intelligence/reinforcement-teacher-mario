//
//  ConfigViewController.swift
//  NESController2
//
//  Created by Stef Janssen on 18/10/14.
//  Copyright (c) 2014 Stef Janssen. All rights reserved.
//

import UIKit
import CoreData

class ConfigViewController: UIViewController, UITextFieldDelegate {


    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    @IBOutlet weak var ipfield: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [User] {
            user = fetchResults[0]
            ipfield!.text = user!.ipaddress
            usernameField.text = user!.myusername
        }
        ipfield.delegate = self
        usernameField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "returnToViewControllerSegue"{
            if let myip = ipfield.text {
                if let myusername = usernameField.text {
                    let fetchRequest = NSFetchRequest(entityName: "User")
                    if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [User] {
                        user = fetchResults[0]
                        user?.ipaddress = myip
                        user?.myusername = myusername
                        managedObjectContext!.save(nil)
                    }
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
