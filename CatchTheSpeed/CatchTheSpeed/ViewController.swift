//
//  ViewController.swift
//  CatchTheSpeed
//
//  Created by Iacopo on 18/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelCongrats: UILabel!
    @IBOutlet weak var fadingView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var modalita: UILabel!
    @IBOutlet weak var puntiAttuali: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var nomePlayer: UILabel!
    @IBOutlet weak var levelText: UILabel!
    @IBOutlet weak var opzioni: UIBarButtonItem!
    @IBOutlet weak var closeSlidingMenu: UIButton!
    @IBOutlet weak var slidingMenu: UIView!
    @IBOutlet weak var table1: UITableViewCell!
    @IBOutlet weak var table2: UITableViewCell!
    @IBOutlet weak var table3: UITableViewCell!
    @IBOutlet weak var acceleratorView: AcceleratorView!
    @IBOutlet weak var changingSurvival: UISwitch!
    
    enum mod : Int {
        case soft = 100
        case stressing = 50
        case survival = 300
        case astonishing = 400
    }
    
    enum timeTicker : NSTimeInterval{
        case quite = 0.09
        case low = 0.04
        case medium = 0.03
        case wow = 0.009
    }
    
    enum buttonLabel : String {
        case start = "Start"
        case stop = "Stop"
    }
    
    var started : Bool = false
    var modGame : mod = mod.soft
    var level : Int = 1
    var minAngle: CGFloat = 0
    var maxAngle : CGFloat = 0
    var counter = 3
    var timerEndGame = NSTimer()
    var currentPoint = 0
    let minDimAngle : CGFloat = (1/90) * CGFloat(M_PI)
    var recordPoint = 0
    var dimAngle : CGFloat = 0
    var counterTime = 60
    var timerMod = NSTimer()
    var optionOpened :Bool = false
    var timer = NSTimer();
    
    
    @IBAction func changingSurvival(sender: AnyObject) {
        switch (self.modGame){
        case mod.soft:
            self.modGame=mod.survival
        case mod.stressing:
            self.modGame = mod.astonishing
        case mod.survival:
            self.modGame=mod.soft
        case mod.astonishing:
            self.modGame = mod.stressing
        default:
            break;
        }
    }
    
    @IBAction func changingTimer(sender: AnyObject) {
        switch (self.modGame){
        case mod.soft:
            self.modGame=mod.stressing
        case mod.stressing:
            self.modGame = mod.soft
        case mod.survival:
            self.modGame=mod.astonishing
        case mod.astonishing:
            self.modGame = mod.survival
        default:
            break;
        }

    }
    
    
    @IBAction func optionClick(sender: AnyObject) {
        if(!self.optionOpened){
            if(self.started){
                self.resetGame()
                self.timer.invalidate()
                self.timerEndGame.invalidate()
                self.timerMod.invalidate()
                self.fadingView.alpha = 0
                self.fadingView.hidden = false
                self.labelCongrats.alpha=0
                self.labelCount.alpha=0
                self.acceleratorView.alpha=1
            }
            var newFrame =  CGRectMake(0, 0, self.slidingMenu.frame.size.width , self.slidingMenu.frame.size.height)
            
            UIView.animateWithDuration(0.5, animations: {
                self.slidingMenu.frame = newFrame;
            })
            self.optionOpened=true
        }else{
            self.closeMenu()
        }
    }
    
    private func closeMenu(){
        var currentFrame = CGRectMake(self.slidingMenu.frame.origin.x, self.slidingMenu.frame.origin.y-self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        
        UIView.animateWithDuration(0.5, animations: {
            self.slidingMenu.frame = currentFrame;
        })
        self.optionOpened = false
        self.changeModView()
        
    }
    
    @IBAction func closingMenu(sender: AnyObject) {
        self.closeMenu()
    }
    
    private func changeModView(){
        switch self.modGame {
        case mod.stressing:
            self.timeLabel.text = String(self.counterTime)
            self.modalita.text = "Stressing"
        case mod.soft:
            self.modalita.text = "Soft"
            self.timeLabel.text = "-"
        case mod.survival:
            self.modalita.text = "Survival"
            self.timeLabel.text = "-"
        case mod.astonishing :
            self.modalita.text = "Astonishing!!"
            self.timeLabel.text = String(self.counterTime)
            
        default:
            break
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slidingMenu.frame = CGRectMake(self.slidingMenu.frame.origin.x, self.slidingMenu.frame.origin.y-self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        self.fadingView.hidden=true
        //self.labelCongrats.hidden=true
        //self.labelCount.hidden=true
        self.labelCongrats.alpha=0
        self.labelCount.alpha=0
        self.calcAngleOnLevel()
                       //FIXME: andranno caricati da risorsa i punti del record
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func resetGame(){
        self.started=false
        self.startButton.setTitle(buttonLabel.start.rawValue, forState: UIControlState.Normal)
        self.level=1
        self.currentPoint=0
        self.puntiAttuali.text = String(self.currentPoint)
        self.levelText.text = String(self.level)
        self.startButton.enabled=true
        self.acceleratorView.resetTicker()
        self.counterTime = 60
        if(self.modGame == mod.stressing || self.modGame == mod.astonishing){
            self.timeLabel.text = String(self.counterTime)
        }
        self.calcAngleOnLevel()
        self.counter=3
        
        
    }
    
    func schedulaGame(tick: NSTimeInterval){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(tick, target: self, selector: Selector("updateGame"), userInfo: nil, repeats: true)
    }
    func schedulaContatore(){
        self.timerMod = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countSec"), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func startGame(sender: AnyObject) {
        switch started  {
        case false:
            
            self.startButton.setTitle(buttonLabel.stop.rawValue, forState: UIControlState.Normal)
            switch(self.modGame){
            case mod.soft:
                self.counter=3
                self.schedulaGame(timeTicker.quite.rawValue)
            case mod.stressing:
                self.schedulaContatore()
                self.timeLabel.text = String(counterTime)
                self.schedulaGame(timeTicker.quite.rawValue)
                
            default:
                break
            }
            started = !started
        default:
            switch self.modGame {
            case mod.stressing:
                var stoppedAngle = self.acceleratorView.getTickerAngle()
                println("min \(minAngle) - max \(maxAngle) - stoppd \(stoppedAngle)")
                if (stoppedAngle >= self.minAngle && stoppedAngle <= self.maxAngle ){
                    self.level++
                    self.currentPoint += self.modGame.rawValue
                    self.updateRecord()
                    self.puntiAttuali.text = String(self.currentPoint)
                    self.calcAngleOnLevel()
                    self.levelText.text = String(self.level)
                }
            case mod.soft:
                //                self.startButton.setTitle(buttonLabel.start.rawValue, forState: UIControlState.Normal)
                self.startButton.enabled=false
                self.timer.invalidate()
                
                var stoppedAngle = self.acceleratorView.getTickerAngle()
                if (stoppedAngle >= self.minAngle && stoppedAngle <= self.maxAngle ){
                    
                    var origFrame = self.fadingView.frame
                    self.fadingView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.width, 0)
                    self.level++
                    self.currentPoint += self.modGame.rawValue
                    
                    UIView.animateWithDuration(0.5, animations: {
                        self.fadingView.frame = origFrame
                        self.fadingView.alpha = 1
                        self.fadingView.hidden = false
                        self.acceleratorView.alpha = 0.4
                        self.labelCount.alpha=1
                        self.labelCongrats.alpha=1
                        }, completion: { finished in
                            UIView.animateWithDuration(1, animations: {
                                self.levelText.text = String(self.level)
                                self.puntiAttuali.text = String(self.currentPoint)
                                self.updateRecord()
                                
                                }, completion: {
                                    finished in
                                    self.timerEndGame = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("messageGame"), userInfo: nil, repeats: true)
                                }
                            )
                        }
                    )
                    
                }else{
                    self.showEndAlert("OH NO!!!", message: "Omg, you have lost! LOSER!", action: "Sadness...")
                }
            default :
                started = !started
            }
            
            
        }
    }
    
    func countSec(){
        if(self.counterTime == 0){
            self.timerMod.invalidate()
            if(self.recordPoint == self.currentPoint){
                self.showEndAlert("Congrats", message: "You have done a new record!", action: "Improve it!")
            }else{
                self.showEndAlert("Ouch!", message: "Your time is up!", action: "Try again")
            }
            self.timer.invalidate()
        }else{
            self.counterTime--
            self.timeLabel.text = String(counterTime)
        }
    }
    
    func updateRecord(){
        if(self.currentPoint > self.recordPoint){
            self.recordPoint = self.currentPoint
            self.record.text = String(self.recordPoint)
        }
        
    }
    
    func showEndAlert(title : String, message : String, action: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Destructive, handler: {finished in
            self.resetGame()
            //            self.started = !self.started
        }))
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func messageGame(){
        //        println("uff \(self.counter)")
        if(self.counter == 1){
            self.timerEndGame.invalidate()
            UIView.animateWithDuration(0.2, animations: {
                
                self.fadingView.alpha = 0
                self.fadingView.hidden = false
                self.labelCongrats.alpha=0
                self.labelCount.alpha=0
                self.acceleratorView.alpha=1
                self.calcAngleOnLevel()
                }, completion: {finished in
                    self.counter=3
                    self.labelCount.text = String(self.counter)
                }
            )
            //            self.startButton.setTitle(buttonLabel.stop.rawValue, forState: UIControlState.Normal)
            var time  = timeTicker.quite.rawValue
            if(self.dimAngle == minAngle){
                time -= 0.002
            }
            self.schedulaGame(time)
            self.startButton.enabled=true
        }else{
            self.counter -= 1
        }
        self.labelCount.text = String(self.counter)
    }
    
    private func randomFloat(min : CGFloat , max : CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (max-min) + min
    }
    
    private func resetCoordinates(){
        let angles = self.acceleratorView.getReferenceAngleValue()
        self.minAngle = angles.min
        self.maxAngle = angles.max
        
    }
    
    private func calcAngleOnLevel(){
        self.resetCoordinates()
        self.dimAngle = (self.maxAngle - self.minAngle) / CGFloat((self.level + 1))
        if( self.dimAngle < minDimAngle){
            self.dimAngle = minDimAngle
        }
        var rnd: CGFloat = self.randomFloat(self.minAngle, max: (self.maxAngle - dimAngle))
        
        minAngle = rnd
        maxAngle = minAngle + dimAngle
        self.acceleratorView.enableYellowSection( minAngle, endingAngle: maxAngle)
    }
    
    
    func updateGame(){
        self.acceleratorView.addTickerAngle()
    }
}

