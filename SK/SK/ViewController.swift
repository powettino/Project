//
//  ViewController.swift
//  SK
//
//  Created by Iacopo Peri on 28/02/15.
//  Copyright (c) 2015 Iacopo Peri. All rights reserved.
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
   
    @IBOutlet weak var sceneView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = Speedo.unarchiveFromFile("Speedo") as? Speedo

        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        scene?.size = sceneView.bounds.size;
        sceneView.presentScene(scene);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return true;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }


}

