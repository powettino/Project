//
//  ViewController.swift
//  CatchTheSpeed
//
//  Created by Iacopo on 18/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var labelCount: UILabel!
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
    var counter = 3;
    var timerEndGame = NSTimer()
    
    
    @IBOutlet weak var acceleratorView: AcceleratorView!
    var timer = NSTimer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calcAngleOnLevel()
        self.fadingView.hidden=true
        self.labelCongrats.hidden=true
        self.labelCount.hidden=true
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
            self.counter=3
            self.startButton.setTitle(buttonLabel.stop.rawValue, forState: UIControlState.Normal)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("updateGame"), userInfo: nil, repeats: true)
            started = !started
        default:
            switch mod {
            case modalita.stressing:
                self.counter=1
            case modalita.soft:
                self.startButton.setTitle(buttonLabel.start.rawValue, forState: UIControlState.Normal)
                self.timer.invalidate()
                started = !started
                var stoppedAngle = self.acceleratorView.getTickerAngle()
                if (stoppedAngle >= self.minAngle && stoppedAngle <= self.maxAngle ){
                    
                    var origFrame = self.fadingView.frame
                    self.fadingView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.width, 0)
                    self.level++
                    UIView.animateWithDuration(0.5, animations: {
                        self.fadingView.frame = origFrame
                        self.fadingView.alpha = 0.7
                        self.fadingView.hidden = false
                        self.levelText.text = String(self.level)
                        }, completion: { finished in
                            UIView.animateWithDuration(1, animations: {
                                self.labelCount.hidden = false
                                self.labelCongrats.hidden = false}, completion: {
                                    finished in
                                    self.timerEndGame = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("messageGame"), userInfo: nil, repeats: true)
                                }
                            )
                        }
                    )
                    
                }else{
                    var alert = UIAlertController(title: "OH NO!!!", message: "Omg, you have lost! LOSER!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "F**K", style: UIAlertActionStyle.Destructive, handler: {finished in
                        self.resetGame()
                        self.level=1
                        self.levelText.text = String(self.level)
                    }))
                    self.presentViewController(alert, animated: true, completion: {})
                }
            default :
                started = !started
            }
            
            
        }
    }
    
    func messageGame(){
        println("uff \(self.counter)")
        if(self.counter == 1){
            
            self.timerEndGame.invalidate()
            UIView.animateWithDuration(0.2, animations: {
                
                self.fadingView.alpha = 0
                self.fadingView.hidden = false}, completion: {finished in
                    self.counter=3
                    self.labelCount.text = String(self.counter)
                }
            )
        }else{
            self.counter -= 1
        }
        self.labelCount.text = String(self.counter)
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

