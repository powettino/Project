//
//  InterfaceController.swift
//  CatchTheSpeed WatchKit Extension
//
//  Created by Iacopo Peri on 30/09/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    
    @IBOutlet weak var titleChart: WKInterfaceLabel!
    @IBOutlet weak var chart: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //
        //        for family in UIFont.familyNames(){
        //            for fontname in UIFont.fontNamesForFamilyName(family as! String){
        //                NSLog("\(fontname)")
        //            }
        //        }
        
        //        WKInterfaceController.openParentApplication(["request": "refreshData"],
        //            reply: { (replyInfo, error) -> Void in
        //                // TODO: process reply data
        //                NSLog("Reply: \(replyInfo)")
        //        })        // Configure interface objects here.
    }
    
    internal func getChart(){
        
        var urlReq : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/Points?order=-score&limit=10&include=user")!)
        
        urlReq.HTTPMethod = "GET"
        urlReq.setValue("7Zn8mV9WPMzBprhPiZDcqOVxlGc6UYNpmTN4qQLs", forHTTPHeaderField: "X-Parse-Application-Id")
        urlReq.setValue("Rv9xdCM7GzTvTz13VeCzE8UEB0UPpmWMC29lAg0k", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlReq, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError!) -> Void in
            var err: NSError
            //            println("\(response!.description) - \(data) - \(error?.localizedDescription)")
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            var resultSet : NSArray = jsonResult["results"] as! NSArray
            self.chart.setNumberOfRows(resultSet.count, withRowType: "ChartRowController")
            
            for (index, singleRes) in enumerate(resultSet){
                if let row = self.chart.rowControllerAtIndex(index) as? ChartRowController {
                    var chartInfo : NSDictionary = singleRes as! NSDictionary
                    var user : NSDictionary = (chartInfo["user"] as? NSDictionary)!
                    row.setInfo(String(index+1), playerName: user["name"] as! String, actualPoints: String(chartInfo["score"] as! Int), gameMod: ModeGame(rawValue: (chartInfo["game_type"] as! Int))!.toString())
                }
            }
        })
    }
    
    internal enum ModeGame : Int {
        case soft = 100
        case stressing = 50
        case survival = 200
        case astonishing = 500
        func toString() -> String{
            switch(self){
            case soft:
                return "Soft"
            case stressing:
                return "Stressing"
            case survival:
                return "Survival"
            case astonishing:
                return "Astonishing"
            default:
                break
            }
        }
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        self.getChart()
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}