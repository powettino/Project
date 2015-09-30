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
                                for family in UIFont.familyNames(){
                                    for fontname in UIFont.fontNamesForFamilyName(family as! String){
                                        NSLog("\(fontname)")
                                    }
                                }

//        let att = NSAttributedString(string: "Fonto", attributes: [NSFontAttributeName : UIFont(name: "Flame", size: 12)!], forKey: NSFontAttributeName)
//        self.titleChart.setAttributedText(att)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func reloadTable(){
        chart.setNumberOfRows(10, withRowType: "CharRowController")
        
        //        for (index, chart) in enumerate(chart) {
        //        if let row = coinTable.rowControllerAtIndex(index) as? CoinRow {
        
        //                row.titleLabel.setText(coin.name)
        //                row.detailLabel.setText("\(coin.price)")
        //            }
        //        }
        
    }
    
}
