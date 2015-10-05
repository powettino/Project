//
//  InterfaceController.swift
//  CatchTheSpeed WatchKit Extension
//
//  Created by Iacopo Peri on 30/09/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceControllerSoft: WKInterfaceController {
    
    
    @IBOutlet weak var titleChart: WKInterfaceLabel!
    @IBOutlet weak var chart: WKInterfaceTable!
    
    var infoArray : NSArray = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.getChart()
    }
    
    internal func getChart(){
        
        var params = ["game_type":InterfaceControllerGlobal.ModeGame.soft.rawValue]
        var error : NSError?
        var whereClause = (NSString(data: NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)!, encoding: NSUTF8StringEncoding))?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        //
        
        //        var urlReq : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/Points?order=-score&limit=10&include=user&where=\(whereClause!)")!)
        //
        //        urlReq.HTTPMethod = "GET"
        //        urlReq.setValue("7Zn8mV9WPMzBprhPiZDcqOVxlGc6UYNpmTN4qQLs", forHTTPHeaderField: "X-Parse-Application-Id")
        //        urlReq.setValue("Rv9xdCM7GzTvTz13VeCzE8UEB0UPpmWMC29lAg0k", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        var urlReq = Utility.prepareRestRequest("https://api.parse.com/1/classes/Points?order=-score&limit=10&include=user&where=\(whereClause!)")
        
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlReq, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError!) -> Void in
            var err: NSError
            //            println("\(response!.description) - \(data) - \(error?.localizedDescription)")
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            self.infoArray = jsonResult["results"] as! NSArray
        })
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        self.chart.setNumberOfRows(self.infoArray.count, withRowType: "ChartRowController")
        
        for (index, singleRes) in enumerate(self.infoArray){
            if let row = self.chart.rowControllerAtIndex(index) as? ChartRowController {
                var chartInfo : NSDictionary = singleRes as! NSDictionary
                var user : NSDictionary = (chartInfo["user"] as? NSDictionary)!
                row.setInfo(String(index+1), playerName: user["name"] as! String, actualPoints: String(chartInfo["score"] as! Int), gameMod: InterfaceControllerGlobal.ModeGame(rawValue: (chartInfo["game_type"] as! Int))!.toString())
            }
        }
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
