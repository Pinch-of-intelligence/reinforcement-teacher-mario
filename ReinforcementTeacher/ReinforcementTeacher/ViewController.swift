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

    // Settings for the server
    let prefix = "http://"
    var myip = "192.168.2.25:8001"
    let serveradress = "/marioserver"
    var username = "no_username"

    // Variables...
    let queue = NSOperationQueue()
    
    // Booleans for the buttons
    var pressedLeft = true;
    var pressedRight = false;
    var pressedFire = false;
    var pressedJump = true;

    
    //these indices correspond to the tag values
    enum ButtonTypes: Int {
        case Left = 1, Right, Fire, Jump
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext!) as User
        user.name = "een naam"
        user.ipaddress = "de ip address"
        
        // Do any additional setup after loading the view, typically from a nib.
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func update() {
        
        var command: String = ""
        if pressedRight{
            command = command + "right"
        }
        else if pressedLeft{
            command = command + "left"
        }
        if pressedJump {
            command = command + "jump"
        }
        if pressedFire {
            command = command + "fire"
        }
        if (queue.operationCount == 0)
        {
            var NESparams = ["option":"pressButtons",  "command":command, "name":username] as Dictionary<String, String>
            let myurl = prefix + myip + serveradress
            let requestSender = HttpRequestSender(params: NESparams, url: myurl)
            queue.addOperation(requestSender)
        }
    }


}

