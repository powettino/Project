//
//  ViewController.swift
//  BurracoScore
//
//  Created by Iacopo on 16/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var start: UIButton!
    
    @IBOutlet weak var figo: CircleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func partito(sender: AnyObject) {
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
    }
    
    func update() {
      self.figo.setnewTickerAngle(newAngle: self.figo.getTickerAngle()+0.0055)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

