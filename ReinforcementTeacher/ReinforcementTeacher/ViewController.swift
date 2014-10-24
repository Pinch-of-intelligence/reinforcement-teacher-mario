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

    var user :User?

    // Settings for the server
    let prefix = "http://"
    let serveradress = "/marioserver"

    // Variables...
    let queue = NSOperationQueue()
    var previousCommand = "";
    
    // Booleans for the buttons
    var pressedLeft = false;
    var pressedRight = false;
    var pressedFire = false;
    var pressedJump = false;
    
    
    //these indices correspond to the tag values
    enum ButtonTypes: Int {
        case Left = 1, Right, Fire, Jump
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext!) as? User
        user!.username = "een naam"
        user!.ipaddress = "192.168.2.17:8001"

        
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
        
        var option = "";
        
        // Determine the command
        if (command == previousCommand)  {
            if("" != command)
            {
                /*
                Date currentDate = new Date();
                Long timeDifference = currentDate.getTime() - lastUpdate.getTime();
                if (timeDifference > 1000)
                {
                    lastUpdate = new Date();
                    option ="refreshTime";
                }
                else
                {
                    return;
                }*/
                return;
            }
            else
            {
                // Do nothing
                return;
            }
        } 
        else {
//            lastUpdate = new Date();
            if (command.isEmpty) {
                option = "releaseButtons";
                println("No command given");
            } else {
                option = "pressButtons";
                println("Command given: " + command);
            }
        }
        previousCommand = command;
        
        if (queue.operationCount == 0 && user != nil)
        {
            var NESparams = ["option":option,  "command":command, "name":"ROland"] as Dictionary<String, String>
            let myurl = prefix + user!.ipaddress + serveradress
            let requestSender = HttpRequestSender(params: NESparams, url: myurl)
            queue.addOperation(requestSender)
        }
    }

    
    @IBAction func touchDown(sender: AnyObject) {
        
        if let buttonType = ButtonTypes(rawValue: sender.tag){
        switch(buttonType)
        {
        case .Left:
        println("Pressed Left")
        pressedLeft = true;
        case .Right:
        println("Pressed Right")
        pressedRight = true;
        case .Fire:
        println("Pressed Fire")
        pressedFire = true;
        case .Jump:
        println("Pressed Jump")
        pressedJump = true;
        default:
        println("Untagged button pressed")
        }
        }
        
    }
    
    @IBAction func touchUpOutside(sender: AnyObject) {
        touchUp(sender)
    }
    @IBAction func touchUpInside(sender: AnyObject) {
        touchUp(sender)
    }
    
    func touchUp(sender: AnyObject)
    {
        
        if let buttonType = ButtonTypes(rawValue: sender.tag){
        switch(buttonType)
        {
        case .Left:
        println("Released Left")
        pressedLeft = false;
        case .Right:
        println("Released Right")
        pressedRight = false;
        case .Fire:
        println("Released Fire")
        pressedFire = false;
        case .Jump:
        println("Released Jump")
        pressedJump = false;
        default:
        println("Released untagged button ")
        }
        }
    }

}

