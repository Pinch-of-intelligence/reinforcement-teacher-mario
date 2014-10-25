//
//  HttpRequestSender.swift
//  NESController2
//
//  Created by Stef Janssen on 18/10/14.
//  Copyright (c) 2014 Stef Janssen. All rights reserved.
//

import Foundation

class HttpRequestSender: NSOperation {

    var url: String
    
    var params: Dictionary<String, String>
    
    var vc: ViewController
    init(params: Dictionary<String, String>, url: String, vc: ViewController) {
        self.params = params
        self.url = url
        self.vc = vc
    }
    
    var available:Bool = true
    
    override func main() -> (){
        post(params, url: url)
    }
    
    func post(params : Dictionary<String, String>, url : String) -> Bool{
        if (available){
            available = false
            var myUrl = url
            myUrl += "?"
            for k in params.keys
            {
                myUrl += k + "=" + params[k]! + "&"
            }
            
            myUrl = myUrl.substringToIndex(myUrl.endIndex.predecessor())
            myUrl = myUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            var url = NSURL(string: myUrl)
            var request = NSMutableURLRequest(URL: url!)
            var session = NSURLSession.sharedSession()
            
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if(error != nil) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.vc.setErrorField("there was an error, please come to our stand:\n" + error!.localizedDescription)
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.vc.setErrorField("")
                    }
                    
                }
                
                self.available = true
            })
            task.resume()
            while !available {
            }
        }
        return true
    }
}
