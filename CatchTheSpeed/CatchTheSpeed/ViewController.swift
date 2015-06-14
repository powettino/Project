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
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! Speedo
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
    @IBOutlet weak var acceleratorView: SKView!
    @IBOutlet weak var changingSurvival: UISwitch!
    
    
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
    
    @IBAction func optionClick(sender: AnyObject) {
        self.apriMenu()
    }
    
    @IBAction func closingMenu(sender: AnyObject) {
        self.closeMenu()
    }
    
    enum mod : Int {
        case soft = 100
        case stressing = 50
        case survival = 300
        case astonishing = 500
    }
    
    enum buttonLabel : String {
        case start = "Start"
        case stop = "Stop"
    }
    
    //    enum tickerAngleMov {
    //        case low, medium, high, higher
    //    }
    
    var started : Bool = false
    var modGame : mod = mod.stressing
    var level : Int = 1
    //    var minAngle: Double = 0
    //    var maxAngle : Double = 0
    var counter = 3
    var timerEndGame = NSTimer()
    var currentPoint = 0
    //    var dimAngle : Double = 0
    var counterTime = 60
    var timerMod = NSTimer()
    var optionOpened :Bool = false
    var scene : Speedo?;
    
    var recordPoint : Int {
        get{
            let ud = NSUserDefaults.standardUserDefaults().integerForKey("recordCatch")
            return ud
        }
        set(value){
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: "recordCatch")
        }
    }
    
    //    private func getTickerMov(definition : tickerAngleMov) -> Double{
    //        switch definition {
    //        case tickerAngleMov.low:
    //            return 1
    //        case tickerAngleMov.medium:
    //            return 2
    //        case tickerAngleMov.high :
    //            return 3.5
    //        case tickerAngleMov.higher:
    //            return 5
    //        default:
    //            break;
    //        }
    //    }
    
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
    
    private func closeMenu(){
        var currentFrame = CGRectMake(self.slidingMenu.frame.origin.x, self.slidingMenu.frame.origin.y-self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        
        UIView.animateWithDuration(0.3,delay:0, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.slidingMenu.frame = currentFrame;
            }, completion:(nil))
        self.optionOpened = false
        self.startButton.enabled = true
        self.changeModView()
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
        
        //        self.scene = Speedo.unarchiveFromFile("Speedo") as? Speedo
        self.scene = Speedo(size: acceleratorView.bounds.size)
        acceleratorView.showsFPS = true
        acceleratorView.showsNodeCount = true
        //        acceleratorView.frame.size.width = self.view.bounds.size.width;
        self.scene?.size = acceleratorView.bounds.size
        self.scene?.scaleMode = SKSceneScaleMode.ResizeFill
        //        var o = self.scene?.childNodeWithName("grid");
        //        o?.position.x = acceleratorView.bounds.size.width/2;
        acceleratorView.presentScene(self.scene!)
        self.scene?.startGame()
        //        self.scene?.enableYellowSection(level);
        
        self.slidingMenu.frame = CGRectMake(self.slidingMenu.frame.origin.x, self.slidingMenu.frame.origin.y-self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        self.fadingView.hidden=true
        //self.labelCongrats.hidden=true
        //self.labelCount.hidden=true
        self.labelCongrats.alpha=0
        self.labelCount.alpha=0
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
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func superReset(){
        //        self.acceleratorView.bloccaTicker()
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
        //        self.acceleratorView.resetTicker()
        self.counterTime = 60
        self.changeModView()
        self.scene?.resetSpeedo();
        //        self.scene?.enableYellowSection(level);
        self.counter=3
    }
    
    func schedulaContatore(){
        self.timerMod = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countSec"), userInfo: nil, repeats: true)
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
            //            self.acceleratorView.bloccaTicker()
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
                self.scene?.changeLevel(self.level);
                //                self.scene?.enableYellowSection(self.level)
                }, completion: {finished in
                    self.counter=3
                    self.labelCount.text = String(self.counter)
                }
            )
            //            var time  = Speedo.NeedleSpeed.medium.rawValue
            //            if(scene?.getDimAnglePointSection() == minAngle){
            //                time -= 0.002
            //        }
            //            self.schedulaGame(time)
            //            self.acceleratorView.animaTicker(time)
            self.startButton.enabled=true
        }else{
            self.counter -= 1
        }
        self.labelCount.text = String(self.counter)
    }
    
    //private func resetCoordinates(){
    //    //        let angles = self.scene!.getReferenceAngleValue()
    //    //        self.minAngle = angles.min
    //    self.minAngle = self.scene!.minDegreeNeedleAngle
    //    //        self.maxAngle = angles.max
    //    self.maxAngle = self.scene!.maxDegreeNeedleAngle
    //    NSLog("min \(minAngle) - max \(maxAngle)");
    //}
}

