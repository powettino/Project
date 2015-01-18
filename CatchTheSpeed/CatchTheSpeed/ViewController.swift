//
//  ViewController.swift
//  CatchTheSpeed
//
//  Created by Iacopo on 18/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var modalita: UILabel!
    @IBOutlet weak var puntiAttuali: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var nomePlayer: UILabel!
    
    enum modalita : String {
        case soft = "soft"
        case stressing = "streeessing"
        case survival = "SURVIVAL"
        case astonishing = "!!ASTONISHING!!"
    }
    
    var mod : modalita = modalita.soft
    var level : Int = 1
    
    
    
    @IBOutlet weak var acceleratorView: AcceleratorView!
    var timer = NSTimer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startGame(sender: AnyObject) {
        
        self.acceleratorView.enableYellowSection(0, endingAngle: 0)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("updateGame"), userInfo: nil, repeats: true)
        
    }
    
    private func calcAngleOnLevel(){
        var maxAngle: CGFLoat = self.acceleratorView.getMaxAngleValue()
        
    }
    
    func updateGame(){
        self.acceleratorView.addTickerAngle()
        self.acceleratorView.setNeedsDisplay()
    }
}

