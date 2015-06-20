//
//  utility.swift
//  CatchTheSpeed
//
//  Created by Iacopo Peri on 19/06/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import Foundation
import UIKit

class UtilityFunction{
    
    internal static func degreesToRadiant(angle : Double) -> CGFloat{
        return CGFloat(angle * (M_PI / 180));
    }
    
    internal static func radiansToDegrees (value:CGFloat) -> Double {
        return Double((value * 180)) / M_PI;
    }
    
    internal static func findXY(radius : CGFloat, centerX : CGFloat, centerY:CGFloat, angle:CGFloat) -> (x: CGFloat, y: CGFloat){
        let puntoX = centerX + (radius * cos(angle))
        let puntoY = centerY + (radius * sin(angle))
        return ( puntoX, puntoY)
    }
    
    internal static func randomDouble(min : Double , max : Double) -> Double{
        return (Double(arc4random())) / Double(UINT32_MAX) * (max-min) + min
    }

    
}