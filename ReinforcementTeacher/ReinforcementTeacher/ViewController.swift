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
    
    
    //CoreData variables
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

    //Background httprequest sender
    var requestSender: HttpRequestSender?
    // Settings for the server
    let prefix = "http://"
    let port = ":8001"
    let serveradress = "/marioserver"

    // Variables...
    let queue = NSOperationQueue()
    var previousCommand = "";
    
    // Booleans for the buttons
    var pressedLeft = false;
    var pressedRight = false;
    var pressedFire = false;
    var pressedJump = false;
    var lastUpdate = NSDate()
    let updateTime = 0.02;
    
    //Error display textfield
    @IBOutlet weak var errorTextField: UITextView!
    
    //these indices correspond to the tag values
    enum ButtonTypes: Int {
        case Left = 1, Right, Fire, Jump
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [User] {
            user = fetchResults[0]
        }
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(updateTime, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
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
                
                var currentDate = NSDate()

                var timeDifference = currentDate.timeIntervalSinceDate(lastUpdate)
                if (timeDifference > 1.0)
                {
                    lastUpdate = NSDate()
                    option = "refreshTime"
                }
                else
                {
                    return;
                }
            }
            else
            {
                // Do nothing
                return;
            }
        } 
        else {
            lastUpdate = NSDate()
            if (command.isEmpty) {
                option = "releaseButtons";
            } else {
                option = "pressButtons";
            }
        }
        previousCommand = command;
        
        if (queue.operationCount == 0 && user != nil)
        {
            var NESparams = ["option":option,  "command":command, "name":self.user!.myusername] as Dictionary<String, String>
            
            var myurl = prefix + user!.ipaddress + port + serveradress
            var second = myurl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            requestSender = HttpRequestSender(params: NESparams, url: second!, vc: self)
            queue.addOperation(requestSender!)
        }
    }

    func setErrorField(text: String)
    {
        var attrs =
        [
            NSForegroundColorAttributeName: UIColor.redColor(),
        ]
        
        let attString = NSAttributedString(string: text, attributes: attrs)
        self.errorTextField.attributedText = attString

    }
    
    @IBAction func touchDown(sender: AnyObject) {
        
        if let buttonType = ButtonTypes(rawValue: sender.tag){
        switch(buttonType)
        {
        case .Left:
        pressedLeft = true;
        case .Right:
        pressedRight = true;
        case .Fire:
        pressedFire = true;
        case .Jump:
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
        pressedLeft = false;
        case .Right:
        pressedRight = false;
        case .Fire:
        pressedFire = false;
        case .Jump:
        pressedJump = false;
        default:
        println("Released untagged button ")
        }
        }
    }

}

