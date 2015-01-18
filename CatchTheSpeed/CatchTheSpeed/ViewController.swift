//
//  ViewController.swift
//  CatchTheSpeed
//
//  Created by Iacopo on 18/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var labelCongrats: UILabel!
    @IBOutlet weak var fadingView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var modalita: UILabel!
    @IBOutlet weak var puntiAttuali: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var nomePlayer: UILabel!
    @IBOutlet weak var levelText: UILabel!
    
    enum modalita : String {
        case soft = "soft"
        case stressing = "streeessing"
        case survival = "SURVIVAL"
        case astonishing = "!!ASTONISHING!!"
    }
    
    enum buttonLabel : String {
        case start = "Start"
        case stop = "Stop"
    }
    
    var started : Bool = false
    var mod : modalita = modalita.soft
    var level : Int = 1
    var minAngle: CGFloat = 0
    var maxAngle : CGFloat = 0
    
    
    @IBOutlet weak var acceleratorView: AcceleratorView!
    var timer = NSTimer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calcAngleOnLevel()
        self.fadingView.hidden=true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func increaseLevel(){
        self.level += self.level++
        self.levelText.text! = String(self.level)
    }
    
    private func resetGame(){
        self.acceleratorView.resetTicker()
        self.calcAngleOnLevel()
    }
    
    
    @IBAction func startGame(sender: AnyObject) {
        switch started  {
        case false:
            self.startButton.setTitle(buttonLabel.stop.rawValue, forState: UIControlState.Normal)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("updateGame"), userInfo: nil, repeats: true)
            started = !started
        default:
            switch mod {
            case modalita.soft:
                self.startButton.setTitle(buttonLabel.start.rawValue, forState: UIControlState.Normal)
                self.timer.invalidate()
                started = !started
                var stoppedAngle = self.acceleratorView.getTickerAngle()
                if (stoppedAngle >= self.minAngle && stoppedAngle <= self.maxAngle ){
//                    var timerEndGame = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("messageGame"), userInfo: nil, repeats: false)
                    
                    var origFrame = self.fadingView.frame
                    self.fadingView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.width, 0)
                    
                    UIView.animateWithDuration(1, animations: {
                        self.fadingView.frame = origFrame
                        
                        self.fadingView.alpha = 0.7
                        self.fadingView.hidden = false
                        }, completion: {
                            
                        }
                    )
                    
                    
                }else{
                    
                }
                self.resetGame()
            default :
                started = !started
            }
            
            
        }
    }
    
    private func calcAngleOnLevel(){
        var angles = self.acceleratorView.getReferenceAngleValue()
        minAngle = angles.min + (angles.1-angles.0)/2
        maxAngle = angles.max
        self.acceleratorView.enableYellowSection( minAngle, endingAngle: angles.max)
    }
    
    func updateGame(){
        self.acceleratorView.addTickerAngle()
    }
}

