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
    
    class IOSDeviceUtility {
        
        private static let iPhone5Bound : (CGFloat, CGFloat) = (320.0, 568.0)
        //        private static let iPhone5SBound : (CGFloat, CGFloat) = (320.0, 568.0)
        private static let iPhone6Bound : (CGFloat, CGFloat)  = (375.0, 667.0)
        private static let iPhone6PlusBound : (CGFloat, CGFloat)  = (414.0, 736.0)
        
        enum IOSDeviceType : String {
            case unknown = "unknown"
            case iPhone5 = "5"
            //            case iPhone5S = "5s"
            case iPhone6 = "6"
            case iPhone6Plus = "6+"
            
            static let allValues = [unknown, iPhone5, iPhone6, iPhone6Plus]
        }
        
        static func IOSDeviceDimension(device: IOSDeviceType) -> (w:CGFloat, h:CGFloat)?{
            switch device{
            case .iPhone5:
                return iPhone5Bound
                //            case .iPhone5S:
                //                return iPhone5SBound
            case .iPhone6:
                return iPhone6Bound
            case .iPhone6Plus:
                return iPhone6PlusBound
            default:
                return nil;
            }
        }
        
        static func checkDevice(bounds:(CGFloat, CGFloat)) -> IOSDeviceUtility.IOSDeviceType{
            for device in IOSDeviceUtility.IOSDeviceType.allValues{
                if let dev = IOSDeviceDimension(device){
                    if(UtilityFunction.compare(bounds, tuple2: dev)){
                        return device
                    }
                }
            }
            return IOSDeviceType.unknown
        }
    }
    
    func iterateTupleWithResultBlock<C,R>(t:C, block:(String,Any)->R) {
        let mirror = reflect(t)
        for i in 0..<mirror.count {
            block(mirror[i].0, mirror[i].1.value)
        }
    }
    
    
    internal static func compare <T:Equatable> (tuple1:(T,T),tuple2:(T,T)) -> Bool
    {
        return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
    }
    
    
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