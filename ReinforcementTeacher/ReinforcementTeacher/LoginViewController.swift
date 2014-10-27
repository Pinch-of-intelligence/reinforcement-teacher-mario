//
//  LoginViewController.swift
//  NESController
//
//  Created by Stef Janssen on 17/10/14.
//  Copyright (c) 2014 Stef Janssen. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var appDel = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        var err: NSErrorPointer = nil
        var results: NSArray = context.executeFetchRequest(request, error: err)!
        
        if results.count > 0 {
            self.view.hidden = true
            self.performSegueWithIdentifier("skipLogin", sender: self)
        } else {
            self.view.hidden = false
        }
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        if self.usernameField.text == "" {
            usernameField.text = "AnonymousUser"
        } else {
            self.performSegueWithIdentifier("loginSegue", sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue"{
            var appDel = UIApplication.sharedApplication().delegate as AppDelegate
            var context: NSManagedObjectContext = appDel.managedObjectContext!
            
            var newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as NSManagedObject
            newUser.setValue("" + usernameField.text, forKey: "myusername")
            newUser.setValue("Mariocontroller.noip.me", forKey: "ipaddress")
            context.save(nil)
            
        } else if segue.identifier == "skipLogin" {
            //do nothing
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
