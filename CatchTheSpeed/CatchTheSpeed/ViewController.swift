//
//  ViewController.swift
//  CatchTheSpeed
//
//  Created by Iacopo on 18/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as Speedo
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

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
        case astonishing = 500
    }
    
    enum timeTicker : NSTimeInterval{
        case fastest = 0.6
        case fast = 1
        case medium = 0.8
        case low = 2
    }
    
    enum buttonLabel : String {
        case start = "Start"
        case stop = "Stop"
    }
    
    enum tickerAngleMov {
        case low, medium, high, higher
    }
    
    var started : Bool = false
    var modGame : mod = mod.stressing
    var level : Int = 1
    var minAngle: Double = 0
    var maxAngle : Double = 0
    var counter = 3
    var timerEndGame = NSTimer()
    var currentPoint = 0
    var minDimAngle : Double = (1/180) * M_PI
    var dimAngle : Double = 0
    var counterTime = 60
    var timerMod = NSTimer()
    var optionOpened :Bool = false
    
    var recordPoint : Int {
        get{
            let ud = NSUserDefaults.standardUserDefaults().integerForKey("recordCatch")
            return ud
        }
        set(value){
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: "recordCatch")
        }
    }
    
    private func getTickerMov(definition : tickerAngleMov) -> Double{
        switch definition {
        case tickerAngleMov.low:
            return 1
        case tickerAngleMov.medium:
            return 2
        case tickerAngleMov.high :
            return 3.5
        case tickerAngleMov.higher:
            return 5
        default:
            break;
        }
    }
    
    @IBAction func resetClick(sender: AnyObject) {
        self.superReset()
    }
    
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
        if(self.started){
            self.superReset()
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
        if(self.started){
            self.superReset()
        }
        
    }
    
    private func apriMenu() {
        if(!self.optionOpened){
            var newFrame =  CGRectMake(self.slidingMenu.frame.origin.x, 0, self.slidingMenu.frame.size.width , self.slidingMenu.frame.size.height)
            
            UIView.animateWithDuration(0.3 , delay: 0, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                self.slidingMenu.frame = newFrame;
                } , completion:(nil))
            self.optionOpened=true
            self.startButton.enabled=false
        }else{
            self.closeMenu()
        }
        
    }
    
    @IBAction func optionClick(sender: AnyObject) {
        self.apriMenu()
    }
    
    private func closeMenu(){
        var currentFrame = CGRectMake(self.slidingMenu.frame.origin.x, self.slidingMenu.frame.origin.y-self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        
        UIView.animateWithDuration(0.3,delay:0, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.slidingMenu.frame = currentFrame;
            }, completion:(nil))
        self.optionOpened = false
        self.startButton.enabled = true
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
        self.startButton.tintColor = UIColor.whiteColor()
        //        self.minDimAngle = self.acceleratorView.getTickerAngleMov()
        
        self.slidingMenu.layer.cornerRadius=30
        self.slidingMenu.layer.borderColor=UIColor.blackColor().CGColor
        self.slidingMenu.layer.borderWidth=1.5
        self.slidingMenu.layer.shadowColor = UIColor.blackColor().CGColor
        self.slidingMenu.layer.shadowOffset = CGSize()
        self.slidingMenu.layer.shadowOpacity = 0.8
        self.slidingMenu.layer.shadowRadius=5.0
        self.record.text = String(self.recordPoint)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func superReset(){
        
        //        self.timer.invalidate()
        self.acceleratorView.bloccaTicker()
        self.timerEndGame.invalidate()
        self.timerMod.invalidate()
        self.fadingView.alpha = 0
        self.fadingView.hidden = false
        self.labelCongrats.alpha=0
        self.labelCount.alpha=0
        self.acceleratorView.alpha=1
        self.resetGame()
        
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
        self.changeModView()
        self.calcAngleOnLevel()
        self.counter=3
        
        
    }
    
    func schedulaContatore(){
        self.timerMod = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countSec"), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func startGame(sender: AnyObject) {
        var stoppedAngle = self.acceleratorView.getTickerAngle()
        println("stopper: \(stoppedAngle)")
        switch started  {
        case false:
            self.startButton.setTitle(buttonLabel.stop.rawValue, forState: UIControlState.Normal)
            switch(self.modGame){
            case mod.soft:
                self.counter=3
                self.acceleratorView.setTickerAngleMov(self.getTickerMov(tickerAngleMov.medium))
                self.acceleratorView.animaTicker(timeTicker.medium.rawValue)
                //                self.schedulaGame(timeTicker.medium.rawValue)
            case mod.stressing:
                //self.acceleratorView.setTickerAngleMov(self.getTickerMov(tickerAngleMov.medium))
                self.timeLabel.text = String(counterTime)
                self.acceleratorView.animaTicker(timeTicker.fast.rawValue)
                //                self.schedulaGame(timeTicker.medium.rawValue)
                self.schedulaContatore()
            case mod.astonishing:
                self.schedulaContatore()
                self.timeLabel.text = String(counterTime)
                //                self.schedulaGame(timeTicker.fast.rawValue)
                self.acceleratorView.setTickerAngleMov(self.getTickerMov(tickerAngleMov.higher))
                self.acceleratorView.animaTicker(timeTicker.fast.rawValue)
                
            case mod.survival:
                self.acceleratorView.setTickerAngleMov(self.getTickerMov(tickerAngleMov.high))
                self.acceleratorView.animaTicker(timeTicker.fast.rawValue)
                //                self.schedulaGame(timeTicker.fast.rawValue)
            default:
                break
            }
            started = !started
            
        default:
            switch self.modGame {
            case mod.stressing:
                println("min \(minAngle) - max \(maxAngle) - stoppd \(stoppedAngle)")
                if (stoppedAngle >= self.minAngle && stoppedAngle <= self.maxAngle ){
                    self.level++
                    self.currentPoint += self.modGame.rawValue
                    self.updateRecord()
                    self.puntiAttuali.text = String(self.currentPoint)
                    self.calcAngleOnLevel()
                    self.levelText.text = String(self.level)
                }
            case mod.astonishing:
                
                if (stoppedAngle >= self.minAngle && stoppedAngle <= self.maxAngle ){
                    self.level++
                    self.currentPoint += self.modGame.rawValue
                    self.updateRecord()
                    self.puntiAttuali.text = String(self.currentPoint)
                    self.calcAngleOnLevel()
                    self.levelText.text = String(self.level)
                }else{
                    //                    self.timer.invalidate()
                    self.timerMod.invalidate()
                    self.acceleratorView.bloccaTicker()
                    //                    self.acceleratorView.resetTicker()
                    self.selectAlert()
                }
                
            case mod.survival:
                if (stoppedAngle >= self.minAngle && stoppedAngle <= self.maxAngle ){
                    self.level++
                    self.currentPoint += self.modGame.rawValue
                    self.updateRecord()
                    self.puntiAttuali.text = String(self.currentPoint)
                    self.calcAngleOnLevel()
                    self.levelText.text = String(self.level)
                }else{
                    //                    self.timer.invalidate()
                    self.acceleratorView.bloccaTicker()
                    //                    self.acceleratorView.resetTicker()
                    self.selectAlert()
                }
            case mod.soft:
                //                self.startButton.setTitle(buttonLabel.start.rawValue, forState: UIControlState.Normal)
                self.startButton.enabled=false
                self.acceleratorView.bloccaTicker()
                //                self.acceleratorView.resetTicker()
                //                self.timer.invalidate()
                
                if (stoppedAngle >= self.minAngle && stoppedAngle <= self.maxAngle ){
                    
                    var origFrame = self.fadingView.frame
                    self.fadingView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.width, 0)
                    self.level++
                    self.currentPoint += self.modGame.rawValue
                    
                    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
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
                    self.selectAlert()
                }
            default :
                break
                
            }
        }
    }
    
    func selectAlert(){
        switch(self.recordPoint, self.modGame){
        case (self.currentPoint-1, _):
            self.showEndAlert("Congrats", message: "You have done a new record!", action: "Improve it!")
        case (_, mod.stressing):
            self.showEndAlert("Ouch!", message: "Your time is up!", action: "Try again")
        case (_, mod.soft):
            self.showEndAlert("OH NO!!!", message: "Omg, you have lost! LOSER!", action: "Sadness...")
        case (_, mod.survival):
            self.showEndAlert("Nice try", message: "You will reborn...again...", action: "Let me live")
        case (_, mod.astonishing):
            self.showEndAlert("Nothing to blame", message: "It still hard for you", action: "I'm not giving up")
        default:
            break;
        }
    }
    
    func countSec(){
        if(self.counterTime == 0){
            self.timerMod.invalidate()
            self.selectAlert()
            //            self.timer.invalidate()
            self.acceleratorView.bloccaTicker()
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
            var time  = timeTicker.medium.rawValue
            if(self.dimAngle == minAngle){
                time -= 0.002
            }
            //            self.schedulaGame(time)
            self.acceleratorView.animaTicker(time)
            self.startButton.enabled=true
        }else{
            self.counter -= 1
        }
        self.labelCount.text = String(self.counter)
    }
    
    private func randomDouble(min : Double , max : Double) -> Double{
        return (Double(arc4random())) / Double(UINT32_MAX) * (max-min) + min
    }
    
    private func resetCoordinates(){
        let angles = self.acceleratorView.getReferenceAngleValue()
        self.minAngle = angles.min
        self.maxAngle = angles.max
        
    }
    
    private func calcAngleOnLevel(){
        self.resetCoordinates()
        self.dimAngle = (self.maxAngle - self.minAngle) / Double((self.level + 7))
        if( self.dimAngle < minDimAngle ){
            self.dimAngle = minDimAngle
        }
        var rnd: Double = self.randomDouble(self.minAngle, max: (self.maxAngle - dimAngle))
        
        minAngle = rnd
        maxAngle = minAngle + dimAngle
        self.acceleratorView.enableYellowSection( minAngle, endingAngle: maxAngle)
    }
    
}

