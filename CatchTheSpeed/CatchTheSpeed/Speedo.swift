//
//  Speedo.swift
//  CatchTheSpeed
//
//  Created by Iacopo Peri on 09/03/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import Foundation
import SpriteKit

class Speedo : SKScene{
    
//
//    override init(size: CGSize) {
//        super.init(size: size)
//        
//        anchorPoint = CGPoint(x: 0, y: 0.0)
//        
//        
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func didMoveToView(view: SKView) {
         sfondo = childNodeWithName("mybox") as! SKSpriteNode
//        sfondo = (childNodeWithName("grid") as? SKSpriteNode)!;
//        sfondo.position = CGPoint(x: 0, y: 0);
//        self.backgroundColor = SKColor.whiteColor();
//        sfondo.position = CGPoint(x: self.size.width, y: self.size.height)
//        addChild(sfondo);
    }
    
}