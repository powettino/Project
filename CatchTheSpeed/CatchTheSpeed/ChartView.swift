//
//  ChartView.swift
//  CatchTheSpeed
//
//  Created by Iacopo Peri on 28/08/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import Foundation
import UIKit

class ChartView : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var chartElementArray : [ChartElement] = [ChartElement]()
    
    @IBOutlet weak var chartTable: UITableView!
    
    override func viewDidLoad() {
        NSLog("Ho caricato load")
        
        var queryUsers = PFUser.query()
        
        var query = PFQuery(className:"Points")
        query.orderByDescending("score")
            .includeKey("user")
            //            .whereKey("Users", matchesQuery: queryUsers!)
            .findObjectsInBackgroundWithBlock({ (gameScores: [AnyObject]?, error: NSError?) -> Void in
                if error != nil {
                    println(error)
                } else if let infos = gameScores as? [PFObject]{
                    for info in infos{
                        let score = info["score"] as! Int
                        let level = info["level"] as! String
                        let profilePic = info["profilePicture"] as! PFFile
                        
                        profilePic.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                            if error == nil {
                                
                            }else{
                                println("cannot load some image from")
                            }
                        }
                        let mod = ViewController.ModeGame(rawValue: info["game_type"] as! Int)
                        
                        let name = (info["user"] as! PFUser).objectForKey("name") as! String
//                        let name = relatedUser?.objectForKey("name") as! String
                        self.chartElementArray.append(ChartElement(id: "a", name: name, score: score, mod: mod!.toString(), level: level))
                        NSLog("con numero \(self.chartElementArray.count)")
                        self.chartTable.reloadData()
                        //                            }
                        //                        })
                        
                    }
                    NSLog("con numero \(self.chartElementArray.count)")
                }
            })
        
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("Ho caricato datasource \(self.chartElementArray.count)")
        return self.chartElementArray.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        NSLog("Ho caricato row")
        return 1
    }
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        NSLog("Ho caricato section")
        return 1
    }
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        var reusableCell : ChartCustomCell? = tableView.dequeueReusableCellWithIdentifier("chartCell", forIndexPath: indexPath) as? ChartCustomCell
        if reusableCell==nil {
            reusableCell = ChartCustomCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "chartCell")
        }
        var element : ChartElement = self.chartElementArray[indexPath.row]
        reusableCell!.score.text = String(element.score)
        reusableCell!.level.text = element.level
        reusableCell!.player.text = element.name
        reusableCell!.mod.text = String(element.mod)
        
        NSLog("ci sono passato")
        
        return reusableCell!;
    }
    
}