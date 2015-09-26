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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "risorse/backgrounds/sfondoMenu.jpg")!)
        UtilityFunction.UIUtility.showActivityIndicator(self.view, tag: 20)
        
        var query = PFQuery(className:"Points")
        query.orderByDescending("score")
            .includeKey("user")
            //                        .whereKey("Users", matchesQuery: queryUsers!)
            .findObjectsInBackgroundWithBlock({ (gameScores: [AnyObject]?, error: NSError?) -> Void in
                if error != nil {
                    UtilityFunction.UIUtility.hideActivityIndicator(self.view, tag: 20)
                    UtilityFunction.UIUtility.showAlertWithContent(self, title: "No connection available", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert, actions: [UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)], animated: true, completion: nil)
                    println(error)
                } else if let infos = gameScores as? [PFObject]{
                    UtilityFunction.UIUtility.hideActivityIndicator(self.view, tag: 20)
                    for infoQuery in infos{
                        let score = infoQuery["score"] as! Int
                        let level = infoQuery["level"] as! String
                        let mod = ViewController.ModeGame(rawValue: infoQuery["game_type"] as! Int)
                        
                        var user = infoQuery["user"] as! PFUser
                        let name = user["name"] as! String
                        self.chartElementArray.append(ChartElement(id: user.objectId!, name: name, score: score, mod: mod!.toString(), level: level, chartPosition: self.chartElementArray.count+1))
                        //                        println("con numero interno\(self.chartElementArray.count)")
                        self.chartTable.reloadData()
                    }
                    NSLog("con numero \(self.chartElementArray.count)")
                }
            })
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chartElementArray.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        var reusableCell : ChartCustomCell? = tableView.dequeueReusableCellWithIdentifier("chartCell", forIndexPath: indexPath) as? ChartCustomCell
        if reusableCell==nil {
            reusableCell = ChartCustomCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "chartCell")
        }
        UtilityFunction.UIUtility.removeAllSubviews(reusableCell!.picture)
        reusableCell?.picture.image = nil
        var element : ChartElement = self.chartElementArray[indexPath.row]
        reusableCell!.score.text = String(element.score)
        reusableCell!.level.text = "Level: \(element.level)"
        reusableCell!.player.text = element.name
        reusableCell!.mod.text = "\(String(element.mod))"
        reusableCell!.chartPosition.text = "\(String(element.chartPosition))˚"
        
        UtilityFunction.UIUtility.showActivityIndicator(reusableCell!.picture, tag: element.chartPosition+1000)
        var query = PFUser.query()
        query?.getObjectInBackgroundWithId(element.id, block: { (result: PFObject?, error: NSError?) -> Void in
            if error == nil{
                let profilePic = result!["profilePicture"] as? PFFile
                if let picture = profilePic {
                    picture.getDataInBackgroundWithBlock { (imageData:NSData?, error: NSError?) -> Void in
                        if error == nil {
                            UtilityFunction.UIUtility.hideActivityIndicator(reusableCell!.picture, tag: element.chartPosition+1000)
                            reusableCell!.picture.clipsToBounds = true
                            reusableCell!.picture.layer.cornerRadius = 10
                            reusableCell!.picture.image = UIImage(data: imageData!)
                        }else{
                            println("Cannot load image from web")
                        }
                    }
                }
            }else{
                println("Cannot load image from web")
            }
        })
        
        //        NSLog("ci sono passato elemento \(element.chartPosition)")
        
        return reusableCell!;
    }
    
}