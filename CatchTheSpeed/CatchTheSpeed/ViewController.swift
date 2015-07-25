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

class ViewController: UIViewController, ScoreDelegate, StartingActionDelegate, OptionMenuDelegate{
    
    @IBOutlet weak var copyLabelCount: UILabel!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var fadingView: UIView!
    @IBOutlet weak var modalita: UILabel!
    @IBOutlet weak var puntiAttuali: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var nomePlayer: UILabel!
    @IBOutlet weak var levelText: UILabel!
    @IBOutlet weak var opzioni: UIBarButtonItem!
    @IBOutlet weak var slidingMenu: UIView!
    @IBOutlet weak var acceleratorView: SKView!
    @IBOutlet weak var container: UIView!
    
    @IBAction func optionClick(sender: AnyObject) {
        self.scene?.pauseNeedle(true);
        if(!self.optionOpened){
            var newFrame =  CGRectMake(self.slidingMenu.frame.origin.x, 0, self.slidingMenu.frame.size.width , self.slidingMenu.frame.size.height)
            UIView.animateWithDuration(0.3 , delay: 0, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
                self.slidingMenu.frame = newFrame;
                } , completion:(nil))
            self.optionOpened=true
        }else{
            self.closeMenu()
        }
    }
    
    enum ModeGame : Int {
        case soft = 100
        case stressing = 50
        case survival = 200
        case astonishing = 500
    }
    
    var modGame : ModeGame = ModeGame.soft
    var level : Int = 1
    var counterMessageGame = 3
    var timerMessageGame = NSTimer()
    var currentPoint = 0
    var counterTimerMode = 60
    var timerStressingMode = NSTimer()
    var optionOpened :Bool = false
    var scene : Speedo?;
    var menu : MenuTable!
    
    var recordPoint : Int {
        get{
            let ud = NSUserDefaults.standardUserDefaults().integerForKey("recordCatch")
            return ud
        }
        set(value){
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: "recordCatch")
        }
    }
    
    func changedSurvival(){
        NSLog("cambiato survvival");
        switch (self.modGame){
        case ModeGame.soft:
            self.modGame=ModeGame.survival
        case ModeGame.stressing:
            self.modGame = ModeGame.astonishing
        case ModeGame.survival:
            self.modGame=ModeGame.soft
        case ModeGame.astonishing:
            self.modGame = ModeGame.stressing
        default:
            break;
        }
    }
    
    func changedTimer() {
        NSLog("cambiato timer");
        switch (self.modGame){
        case ModeGame.soft:
            self.modGame=ModeGame.stressing
        case ModeGame.stressing:
            self.modGame = ModeGame.soft
        case ModeGame.survival:
            self.modGame=ModeGame.astonishing
        case ModeGame.astonishing:
            self.modGame = ModeGame.survival
        default:
            break;
        }
    }
    
    func changedSounds() {
        NSLog("cambiato sound");
        switch (self.modGame){
        case ModeGame.soft:
            self.modGame=ModeGame.stressing
        case ModeGame.stressing:
            self.modGame = ModeGame.soft
        case ModeGame.survival:
            self.modGame=ModeGame.astonishing
        case ModeGame.astonishing:
            self.modGame = ModeGame.survival
        default:
            break;
        }
    }
    
    func changedEffects() {
        NSLog("cambiato effects");
        switch (self.modGame){
        case ModeGame.soft:
            self.modGame=ModeGame.stressing
        case ModeGame.stressing:
            self.modGame = ModeGame.soft
        case ModeGame.survival:
            self.modGame=ModeGame.astonishing
        case ModeGame.astonishing:
            self.modGame = ModeGame.survival
        default:
            break;
        }
    }
    
    func closeMenu(){
        var currentFrame = CGRectMake(self.slidingMenu.frame.origin.x, self.slidingMenu.frame.origin.y-self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        
        UIView.animateWithDuration(0.3,delay:0, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.slidingMenu.frame = currentFrame;
            }, completion:(nil))
        
        self.optionOpened = false
        if(self.changeModeView()){
            self.scene?.resetSpeedo()
            self.restartGame()
        }
        self.scene?.pauseNeedle(false);
    }
    
    func restartGame(){
        self.timerMessageGame.invalidate()
        self.timerStressingMode.invalidate()
        self.fadingView.alpha = 0
        self.fadingView.hidden = false
        self.labelText.alpha=0
        self.labelCount.alpha=0
        self.copyLabelCount.alpha=0
        self.acceleratorView.alpha=1
        //        self.started=false
        self.level=1
        self.currentPoint=0
        self.puntiAttuali.text = String(self.currentPoint)
        self.levelText.text = String(self.level)
        self.counterTimerMode = 60
        self.timeLabel.text = (self.timeLabel.text == "-") ? "-" : String(self.counterTimerMode)
        //        self.changeModeView()
        self.scene?.resetSpeedo();
        self.counterMessageGame=3
    }
    
    func updateRecord(){
        if(self.currentPoint > self.recordPoint){
            self.recordPoint = self.currentPoint
            self.record.text = String(self.recordPoint)
        }
    }
    
    func selectAlert(){
        switch(self.recordPoint, self.modGame){
        case (self.currentPoint-1, _):
            self.showEndAlert("Congrats", message: "You have done a new record!", action: "Improve it!")
        case (_, ModeGame.stressing):
            self.showEndAlert("Ouch!", message: "Your time is up!", action: "Try again")
        case (_, ModeGame.soft):
            self.showEndAlert("OH NO!!!", message: "Omg, you have lost! LOSER!", action: "Sadness...")
        case (_, ModeGame.survival):
            self.showEndAlert("Nice try", message: "You will reborn...again...", action: "Let me live")
        case (_, ModeGame.astonishing):
            self.showEndAlert("Nothing to blame", message: "It still hard for you", action: "I'm not giving up")
        default:
            break;
        }
    }
    
    private func changeModeView() -> Bool{
        var changed : Bool! = false;
        switch (self.modGame, self.modalita.text!) {
        case (ModeGame.stressing, "Stressing"):
            break;
        case (ModeGame.soft, "Soft"):
            break;
        case (ModeGame.survival, "Survival"):
            break;
        case (ModeGame.astonishing, "Astonishing!!") :
            break;
        case (ModeGame.soft, _):
            NSLog("Cambio modalita in soft");
            self.labelText.text = "Congrats!"
            self.modalita.text = "Soft"
            self.timeLabel.text = "-"
            changed=true;
        case (ModeGame.stressing, _):
            NSLog("Cambio modalita in stressing");
            self.timeLabel.text = String(self.counterTimerMode)
            self.modalita.text = "Stressing"
            NSLog("time: \(self.timeLabel.text)")
            changed=true;
        case (ModeGame.survival, _):
            NSLog("Cambio modalita in survival");
            self.modalita.text = "Survival"
            self.timeLabel.text = "-"
            changed=true;
        case (ModeGame.astonishing, _) :
            NSLog("Cambio modalita in astonishing");
            self.modalita.text = "Astonishing!!"
            self.timeLabel.text = String(self.counterTimerMode)
            NSLog("time: \(self.timeLabel.text)")
            changed=true;
        default:
            break
        }
        return changed;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        for family in UIFont.familyNames(){
        //            for fontname in UIFont.fontNamesForFamilyName(family as! String){
        //                NSLog("\(fontname)")
        //            }
        //        }
        
        setElementPositionFromDimension()
        
        self.scene = Speedo(size: self.acceleratorView.bounds.size)
        self.acceleratorView.showsFPS = true
        self.acceleratorView.showsNodeCount = true
        self.scene?.size = self.acceleratorView.bounds.size
        self.scene?.scaleMode = SKSceneScaleMode.ResizeFill
        self.acceleratorView.presentScene(self.scene!)
        scene?.scoreDelegate = self;
        scene?.startingActionDelegate = self;
        scene?.enableTouchStartGame(true);
        
        
        self.fadingView.hidden=true
        
        self.labelText.alpha=0
        self.labelCount.alpha=0
        self.copyLabelCount.alpha=0
        
        self.slidingMenu.layer.cornerRadius=30
        self.slidingMenu.layer.borderColor=UIColor.orangeColor().CGColor
        self.slidingMenu.layer.borderWidth=1
        self.slidingMenu.layer.shadowColor = UIColor.redColor().CGColor
        self.slidingMenu.layer.shadowOffset = CGSize()
        self.slidingMenu.layer.shadowOpacity = 0.8
        self.slidingMenu.layer.shadowRadius=5.0
        
        self.container.layer.cornerRadius=30
        
        self.record.text = String(self.recordPoint)
        
        self.menu = self.container.subviews[0] as! MenuTable
        self.menu.layer.cornerRadius=30
        self.menu.menuDelegate = self
        self.menu.backgroundColor = UIColor.redColor()
        self.menu.backgroundColor = UIColor(patternImage: UIImage(named: "sfondoMenu.jpg")!)
        
        let deviceNumberType = UtilityFunction.IOSDeviceUtility.checkDevice(view)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sfondo\(deviceNumberType.rawValue).png")!)
    }
    
    private func setElementPositionFromDimension(){
        
        var offset = Speedo.getAccelleratorViewOffset(self.view)
        
        self.slidingMenu.frame = CGRectMake(self.slidingMenu.frame.origin.x, 63-self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        self.acceleratorView.frame.size.width = self.view.frame.width
        self.acceleratorView.frame.size.height = self.view.frame.width
        self.acceleratorView.frame.origin.x = 0
        self.acceleratorView.frame.origin.y = self.view.frame.height - self.acceleratorView.frame.size.height - offset.h
        self.fadingView.frame.origin.x = (self.view.frame.size.width-self.fadingView.frame.size.width) / 2
        self.fadingView.frame.origin.y = self.acceleratorView.frame.origin.y + 30
    }
    
    func counterDescreaseFunction(){
        if(self.counterTimerMode == 0){
            self.timerStressingMode.invalidate()
            self.selectAlert()
            self.scene?.stopNeedle();
        }else{
            self.counterTimerMode--
            self.timeLabel.text = String(counterTimerMode)
        }
    }
    
    func showEndAlert(title : String, message : String, action: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Destructive, handler:{
            finished in
            self.restartGame()
        }))
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func messageGame(){
        if(self.counterMessageGame == 1){
            self.timerMessageGame.invalidate()
            UIView.animateWithDuration(0.2, animations: {
                self.fadingView.alpha = 0
                self.fadingView.hidden = false
                self.labelText.alpha=0
                self.labelCount.alpha=0
                self.copyLabelCount.alpha=0
                self.acceleratorView.alpha=1
                }, completion: {finished in
                    self.labelCount.frame = CGRectMake(self.view.frame.width/2 - self.labelCount.frame.width/2, self.labelCount.frame.origin.y, self.labelCount.frame.width, self.labelCount.frame.height);
                    self.copyLabelCount.frame = CGRectMake(self.view.frame.width/2 - self.labelCount.frame.width/2, self.copyLabelCount.frame.origin.y, self.copyLabelCount.frame.width, self.copyLabelCount.frame.height);
                    
                    self.counterMessageGame=3
                    self.labelCount.text = String(self.counterMessageGame)
                    self.copyLabelCount.text = String(self.counterMessageGame)
                    self.scene?.setLevel(self.level);
                    if(!self.optionOpened){
                        self.scene?.pauseNeedle(false);
                    }
                    self.scene?.updateCollisionSection(nil);
                }
            )
        }else{
            self.counterMessageGame -= 1
            println("valore> \((self.fadingView.frame.width - self.labelCount.frame.width)/2)")
            var middleFrame = CGRectMake((self.fadingView.frame.width - self.labelCount.frame.width)/2, self.labelCount.frame.origin.y, self.labelCount.frame.width, self.labelCount.frame.height);
            
            UtilityFunction.animateHorizontalElementOnMiddleBreak(self.view, toAnimate: self.labelCount, middlePosition: middleFrame, completeDuration: self.timerMessageGame.timeInterval, complex: ((self.counterMessageGame==2) ? "left" : "right"), finalComplention: nil);
            
            UtilityFunction.animateHorizontalElementOnMiddleBreak(self.view, toAnimate: self.copyLabelCount, middlePosition: middleFrame, completeDuration: self.timerMessageGame.timeInterval,complex: ((self.counterMessageGame==1) ? "left" : "right"), finalComplention: nil);
            
            self.labelCount.text = String(self.counterMessageGame)
            self.copyLabelCount.text = String(self.counterMessageGame)
        }
    }
    
    func checkTimeToSpeedUp(){
        //        if(self.scene?.isMinimunSectionDimension() == true){
        if(self.level >= 5){
            var increasing : CGFloat = CGFloat(self.level) / 25.0
            self.scene?.increaseSpeedTo(increasing);
            if((self.level % 5) == 0){
                self.scene?.animateText(nil)
            }
        }
        //    }
    }
    
    
    func startedGame() {
        switch(self.modGame){
        case ModeGame.soft:
            self.counterMessageGame=3
            self.scene?.setNeedleSpeed(Speedo.Needle.NeedleSpeed.low)
            self.scene?.enableFailDelegate(true);
        case ModeGame.stressing:
            self.scene?.setNeedleSpeed(Speedo.Needle.NeedleSpeed.medium)
            self.timeLabel.text = String(self.counterTimerMode)
            self.timerStressingMode = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("counterDescreaseFunction"), userInfo: nil, repeats: true)
            
            self.scene?.enableFailDelegate(false);
        case ModeGame.survival:
            self.scene?.setNeedleSpeed(Speedo.Needle.NeedleSpeed.fast)
            self.scene?.enableFailDelegate(true);
        case ModeGame.astonishing:
            self.timerStressingMode = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("counterDescreaseFunction"), userInfo: nil, repeats: true)
            
            self.timeLabel.text = String(self.counterTimerMode)
            self.scene?.setNeedleSpeed(Speedo.Needle.NeedleSpeed.fastest)
            self.scene?.enableFailDelegate(false);
        default:
            break
        }
        self.scene?.startGame();
    }
    
    func setFail(){
        switch self.modGame{
        case ModeGame.soft:
            self.scene?.stopNeedle();
            self.selectAlert();
        case ModeGame.survival:
            self.scene?.stopNeedle();
            self.selectAlert()
        default:
            break;
        }
    }
    
    func setPoint(){
        self.currentPoint += self.modGame.rawValue
        self.level++
        self.updateRecord()
        self.puntiAttuali.text = String(self.currentPoint)
        self.levelText.text = String(self.level)
        switch self.modGame {
        case ModeGame.stressing, ModeGame.astonishing, ModeGame.survival:
            self.scene?.updateCollisionSection(self.level);
            self.checkTimeToSpeedUp()
        case ModeGame.soft:
            self.scene?.pauseNeedle(true);
            var origFrame = self.fadingView.frame
            self.fadingView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.width, 0)
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.fadingView.frame = origFrame
                self.fadingView.alpha = 1
                self.fadingView.hidden = false
                self.acceleratorView.alpha = 0.4
                self.labelText.alpha=1
                }, completion: { finished in
                    self.labelCount.alpha=1;
                    self.copyLabelCount.alpha=1;
                    var duration : NSTimeInterval = 0.8;
                    UtilityFunction.animateHorizontalElementOnMiddleBreak(self.view, toAnimate: self.labelCount, middlePosition: self.labelCount.frame, completeDuration: duration,complex: "right", finalComplention: nil);
                    
                    UtilityFunction.animateHorizontalElementOnMiddleBreak(self.view, toAnimate: self.copyLabelCount, middlePosition: self.copyLabelCount.frame, completeDuration: duration, complex: "left", finalComplention: nil);
                    
                    self.timerMessageGame = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: Selector("messageGame"), userInfo: nil, repeats: true)
                }
            )
        default :
            break;
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
}




