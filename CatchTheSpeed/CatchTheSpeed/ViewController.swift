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
            let speedoScene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! Speedo
            archiver.finishDecoding()
            return speedoScene
        } else {
            return nil
        }
    }
}

class ViewController: UIViewController, ScoreDelegate, StartingActionDelegate, TimerDelegate, OptionMenuDelegate{
    
    @IBOutlet weak var copyLabelCount: UILabel!
    @IBOutlet weak var labelText: UILabel!
    //    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var fadingView: UIView!
    @IBOutlet weak var puntiAttuali: UILabel!
    //    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var nomePlayer: UILabel!
    @IBOutlet weak var opzioni: UIBarButtonItem!
    @IBOutlet weak var slidingMenu: UIView!
    @IBOutlet weak var acceleratorView: SKView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var windowInformations: UIView!
    @IBOutlet weak var pointText: UILabel!
    @IBOutlet weak var levelText: UILabel!
    @IBOutlet weak var currentLevel: UILabel!
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBAction func playMod(sender: AnyObject) {
        self.startedGame()
    }
    
    @IBAction func optionClick(sender: AnyObject) {
        self.speedoScene?.pauseSpeedo(true);
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
    
    enum SlideScore : CGFloat {
        case top = -140
        case down = 0
    }
    
    var modGame : ModeGame = ModeGame.soft
    var level : Int = 1
    var counterMessageGame = 3
    var timerMessageGame = NSTimer()
    var currentPoint = 0
    var counterTimerMode = 60
    //    var timerStressingMode = NSTimer()
    var optionOpened :Bool = false
    var speedoScene : Speedo?;
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
    }
    
    func changedEffects() {
        NSLog("cambiato effects");
    }
    
    func closeMenu(){
        var currentFrame = CGRectMake(self.slidingMenu.frame.origin.x, self.slidingMenu.frame.origin.y-self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        
        UIView.animateWithDuration(0.3,delay:0, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.slidingMenu.frame = currentFrame;
            }, completion:(nil))
        
        self.optionOpened = false
        if(self.changeModeView()){
            //            self.speedoScene?.resetSpeedo()
            self.restartGame()
        }
        self.speedoScene?.pauseSpeedo(false);
    }
    
    func restartGame(){
        self.speedoScene?.resetSpeedo();
        self.slideInformationView(SlideScore.down)
        self.timerMessageGame.invalidate()
        //        self.timerStressingMode.invalidate()
        self.fadingView.alpha = 0
        self.fadingView.hidden = false
        self.labelText.alpha=0
        self.labelCount.alpha=0
        self.copyLabelCount.alpha=0
        self.acceleratorView.alpha=1
        self.level=1
        self.currentPoint=0
        self.puntiAttuali.text = String(self.currentPoint)
        self.currentLevel.text = String(self.level)
        self.counterTimerMode = 60
        self.counterMessageGame=3
    }
    
    func updateRecord(){
        if(self.currentPoint > self.recordPoint){
            self.recordPoint = self.currentPoint
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
        switch (self.modGame, self.playButton.titleLabel!.text!.substringFromIndex(advance(self.playButton.titleLabel!.text!.startIndex, 5))) {
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
            self.playButton.setTitle("Play Soft", forState: UIControlState.Normal)
            self.speedoScene?.enableTimer(false);
            changed=true;
        case (ModeGame.stressing, _):
            NSLog("Cambio modalita in stressing");
            self.playButton.setTitle("Play Stressing", forState: UIControlState.Normal)
            self.speedoScene?.enableTimer(true);
            changed=true;
        case (ModeGame.survival, _):
            NSLog("Cambio modalita in survival");
            self.playButton.setTitle("Play Survival", forState: UIControlState.Normal)
            self.speedoScene?.enableTimer(false);
            changed=true;
        case (ModeGame.astonishing, _) :
            NSLog("Cambio modalita in astonishing");
            self.playButton.setTitle("Play Astonishing", forState: UIControlState.Normal)
            self.speedoScene?.enableTimer(true);
            changed=true;
        default:
            break
        }
        return changed;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //                for family in UIFont.familyNames(){
        //                    for fontname in UIFont.fontNamesForFamilyName(family as! String){
        //                        NSLog("\(fontname)")
        //                    }
        //                }
        
        setElementPositionFromDimension()
        
        self.speedoScene = Speedo(size: self.acceleratorView.bounds.size)
        self.acceleratorView.showsFPS = true
        self.acceleratorView.showsNodeCount = true
        self.speedoScene?.size = self.acceleratorView.bounds.size
        self.speedoScene?.scaleMode = SKSceneScaleMode.ResizeFill
        self.acceleratorView.presentScene(self.speedoScene!)
        speedoScene?.scoreDelegate = self;
        speedoScene?.startingActionDelegate = self;
        speedoScene?.timerDelegate = self;
        speedoScene?.enableTouchStartGame(true);
        
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
        
        //        self.record.text = String(self.recordPoint)
        
        self.menu = self.container.subviews[0] as! MenuTable
        self.menu.layer.cornerRadius=30
        self.menu.menuDelegate = self
        self.menu.backgroundColor = UIColor.redColor()
        self.menu.backgroundColor = UIColor(patternImage: UIImage(named: "risorse/backgrounds/sfondoMenu.jpg")!)
        
        let deviceNumberType = UtilityFunction.IOSDeviceUtility.checkDevice(view)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "risorse/backgrounds/sfondo\(deviceNumberType.rawValue).png")!)
        
        self.windowInformations.layer.cornerRadius = 15
        self.windowInformations.layer.borderColor = UIColor(patternImage: UIImage(named: "risorse/borders/texture.png")!).CGColor
        self.windowInformations.layer.borderWidth = 10
        //        self.windowInformations.layer.shadowColor = UIColor.redColor().CGColor
        //        self.windowInformations.layer.shadowOffset = CGSize()
        //        self.windowInformations.layer.shadowRadius = 5
        //        self.windowInformations.layer.shadowOpacity = 1
        self.windowInformations.backgroundColor = UIColor(white: 100, alpha: 0.2)
        
        
        self.puntiAttuali.layer.borderColor = UIColor(patternImage: UIImage(named: "risorse/borders/texture_mini.png")!).CGColor
        self.puntiAttuali.layer.borderWidth = 3
        self.puntiAttuali.layer.cornerRadius = 10
        
        self.currentLevel.layer.borderColor = UIColor(patternImage: UIImage(named: "risorse/borders/texture_mini.png")!).CGColor
        self.currentLevel.layer.borderWidth = 3
        self.currentLevel.layer.cornerRadius = 10
    }
    
    func slideInformationView(position : SlideScore){
        if(position.rawValue != self.informationView.frame.origin.y){
            var slidingFrame = CGRectMake(self.informationView.frame.origin.x, position.rawValue, self.informationView.frame.size.width, self.informationView.frame.size.height)
            
            var pointSlide = CGRectMake(position.rawValue != 0 ? -10 : -self.puntiAttuali.frame.size.width-20 , self.puntiAttuali.frame.origin.y, self.puntiAttuali.frame.size.width, self.puntiAttuali.frame.size.height);
            
            var levelSlide = CGRectMake(position.rawValue != 0 ? self.view.frame.size.width-self.currentLevel.frame.size.width+10 : self.view.frame.size.width+10, self.currentLevel.frame.origin.y, self.currentLevel.frame.size.width, self.currentLevel.frame.size.height);
            
            UIView.animateWithDuration(0.5 ,delay: position.rawValue != 0 ? 0 : 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.informationView.frame = slidingFrame;
                }, completion:(nil))
            
            
            UIView.animateWithDuration(0.5, delay: position.rawValue != 0 ? 0.2 : 0, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {self.currentLevel.frame = levelSlide
                }, completion: (nil))
            
            UIView.animateWithDuration(0.5, delay: position.rawValue != 0 ? 0.2 : 0, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {self.puntiAttuali.frame = pointSlide
                }, completion: (nil))
        }
    }
    
    private func setElementPositionFromDimension(){
        
        var offset = Speedo.getSpeedoViewOffset(self.view)
        
        self.acceleratorView.frame.size.width = self.view.frame.width
        self.acceleratorView.frame.size.height = self.view.frame.width
        self.acceleratorView.frame.origin.x = 0
        self.acceleratorView.frame.origin.y = self.view.frame.height - self.acceleratorView.frame.size.height - offset.h
        self.acceleratorView.layer.zPosition = 2
        
        self.fadingView.frame.origin.x = (self.view.frame.size.width-self.fadingView.frame.size.width) / 2
        self.fadingView.frame.origin.y = self.acceleratorView.frame.origin.y + 30
        
        self.slidingMenu.frame = CGRectMake(self.slidingMenu.frame.origin.x, -self.slidingMenu.frame.size.height, self.slidingMenu.frame.size.width, self.slidingMenu.frame.size.height)
        
        self.slidingMenu.layer.zPosition = 10
        
        self.windowInformations.frame = CGRectMake(5, self.windowInformations.frame.origin.y+5, self.view.frame.size.width-10, self.windowInformations.frame.size.height)
        
        self.informationView.frame.size.width = self.view.frame.size.width-10
        
        
        println("ooo \(self.view.frame.size.height - self.acceleratorView.frame.size.height - offset.h)")
        
        self.currentLevel.frame.origin.x = self.view.frame.size.width + 10
        self.currentLevel.frame.size.width = self.view.frame.size.width/2 - 15
        
        self.levelText.frame.origin.x = (self.view.frame.size.width/2 - 15) + 45
        
        self.puntiAttuali.frame.size.width = self.view.frame.size.width/2 - 15
        self.puntiAttuali.frame.origin.x = -self.puntiAttuali.frame.size.width - 10
        
        self.pointText.frame.origin.x = (self.view.frame.size.width/2 - 15) - self.pointText.frame.size.width - 30
        
        self.gameTitle.frame.origin.x = ((self.view.frame.size.width - 10) - self.gameTitle.frame.size.width) / 2
        self.playButton.frame.origin.x = (self.view.frame.size.width - self.playButton.frame.size.width) / 2
    }
    
    //    func counterDescreaseFunction(){
    //        if(self.counterTimerMode == 0){
    //            self.timerStressingMode.invalidate()
    //            self.selectAlert()
    //            self.speedoScene?.stopSpeedo();
    //        }else{
    //            self.counterTimerMode--
    //            //            self.speedoScene?.updateTimer(self.counterTimerMode)
    //            //            self.timeLabel.text = String(counterTimerMode)
    //        }
    //    }
    
    func showEndAlert(title : String, message : String, action: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Destructive, handler:{
            finished in
            //            self.slideInformationView(SlideScore.top)
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
                    self.speedoScene?.setLevel(self.level);
                    if(!self.optionOpened){
                        self.speedoScene?.pauseSpeedo(false);
                    }
                    self.speedoScene?.updateCollisionSection(nil);
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
        //        if(self.speedoScene?.isMinimunSectionDimension() == true){
        if(self.level >= 5){
            var increasing : CGFloat = CGFloat(self.level) / 25.0
            self.speedoScene?.increaseSpeedTo(increasing);
            if((self.level % 5) == 0){
                self.speedoScene?.animateText(nil)
            }
        }
        //    }
    }
    
    func timerEnded(){
        //        self.timerStressingMode.invalidate()
        self.selectAlert()
        self.speedoScene?.stopSpeedo();
    }
    
    func startedGame() {
        switch(self.modGame){
        case ModeGame.soft:
            self.counterMessageGame=3
            self.speedoScene?.setNeedleSpeed(Speedo.Needle.NeedleSpeed.low)
            self.speedoScene?.enableFailDelegate(true);
        case ModeGame.stressing:
            self.speedoScene?.setNeedleSpeed(Speedo.Needle.NeedleSpeed.medium)
            //            self.timeLabel.text = String(self.counterTimerMode)
            //            self.timerStressingMode = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("counterDescreaseFunction"), userInfo: nil, repeats: true)
            self.speedoScene?.enableFailDelegate(false);
        case ModeGame.survival:
            self.speedoScene?.setNeedleSpeed(Speedo.Needle.NeedleSpeed.fast)
            self.speedoScene?.enableFailDelegate(true);
        case ModeGame.astonishing:
            //            self.timerStressingMode = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("counterDescreaseFunction"), userInfo: nil, repeats: true)
            //            self.timeLabel.text = String(self.counterTimerMode)
            self.speedoScene?.setNeedleSpeed(Speedo.Needle.NeedleSpeed.fastest)
            self.speedoScene?.enableFailDelegate(false);
        default:
            break
        }
        self.slideInformationView(SlideScore.top);
        self.speedoScene?.startSpeedo()
    }
    
    func setFail(){
        switch self.modGame{
        case ModeGame.soft:
            self.speedoScene?.stopSpeedo();
            self.selectAlert();
        case ModeGame.survival:
            self.speedoScene?.stopSpeedo();
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
        self.currentLevel.text = String(self.level)
        switch self.modGame {
        case ModeGame.stressing, ModeGame.astonishing, ModeGame.survival:
            self.speedoScene?.updateCollisionSection(self.level);
            self.checkTimeToSpeedUp()
        case ModeGame.soft:
            self.speedoScene?.pauseSpeedo(true);
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