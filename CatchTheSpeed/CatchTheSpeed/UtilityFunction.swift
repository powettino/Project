//
//  utility.swift
//  CatchTheSpeed
//
//  Created by Iacopo Peri on 19/06/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class UtilityFunction{
    
    class SpriteKitUtility {
        static func removeNodeFromParentWithName(parent: SKNode , nodeName : String){
            parent.enumerateChildNodesWithName(nodeName) {
                node, stop in
                node.removeFromParent();
            }
        }
        static func removeNodesFromParentWIthNames(parent: SKNode , nodesName : [String]){
            for name in nodesName{
                removeNodeFromParentWithName(parent, nodeName: name)
            }
        }
    }
    
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
            for device in IOSDeviceType.allValues{
                if let dev = IOSDeviceDimension(device){
                    if(UtilityFunction.Coding.compare(bounds, tuple2: dev)){
                        return device
                    }
                }
            }
            return IOSDeviceType.unknown
        }
        
        static func checkDevice(view: UIView) -> IOSDeviceUtility.IOSDeviceType{
            for device in IOSDeviceType.allValues{
                if let dev = IOSDeviceDimension(device){
                    if(UtilityFunction.Coding.compare((view.frame.width, view.frame.height), tuple2: dev)){
                        return device
                    }
                }
            }
            return IOSDeviceType.unknown
        }
    }
    class Coding{
        static func iterateTupleWithResultBlock<C,R>(t:C, block:(String,Any)->R) {
            let mirror = reflect(t)
            for i in 0..<mirror.count {
                block(mirror[i].0, mirror[i].1.value)
            }
        }
        
        static func compare <T:Equatable> (tuple1:(T,T),tuple2:(T,T)) -> Bool
        {
            return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
        }
    }
    
    class Math{
        static func degreesToRadiant(angle : Double) -> CGFloat{
            return CGFloat(angle * (M_PI / 180));
        }
        
        static func radiansToDegrees (value:CGFloat) -> Double {
            return Double((value * 180)) / M_PI;
        }
        
        static func findXY(radius : CGFloat, centerX : CGFloat, centerY:CGFloat, angle:CGFloat) -> (x: CGFloat, y: CGFloat){
            let puntoX = centerX + (radius * cos(angle))
            let puntoY = centerY + (radius * sin(angle))
            return ( puntoX, puntoY)
        }
        
        static func randomDouble(min : Double , max : Double) -> Double{
            return (Double(arc4random())) / Double(UINT32_MAX) * (max-min) + min
        }
    }
    
    class Animation{
        static func animateHorizontalElementOnMiddleBreak(containerView: UIView, toAnimate : UIView, middlePosition : CGRect, completeDuration: NSTimeInterval, complex : String?, finalComplention: ((result: Bool) -> Void)?){
            if(complex != nil){
                var starting: CGRect!
                if(complex == "left"){
                    starting = CGRectMake(containerView.frame.width+middlePosition.width+10, middlePosition.origin.y, middlePosition.width, middlePosition.height)
                }else{
                    starting = CGRectMake(-middlePosition.width, middlePosition.origin.y, middlePosition.width, middlePosition.height)
                }
                toAnimate.frame = starting;
                UIView.animateWithDuration(completeDuration/5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    toAnimate.frame = middlePosition;
                    }, completion: {finished in
                        UIView.animateWithDuration(completeDuration/5, delay: completeDuration*(3/5), options: UIViewAnimationOptions.CurveEaseIn, animations: {
                            toAnimate.frame = starting
                            }, completion :
                            finalComplention)
                })
            }else{
                toAnimate.frame = CGRectMake(-middlePosition.width, middlePosition.origin.y, middlePosition.width, middlePosition.height)
                UIView.animateWithDuration(completeDuration/5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    toAnimate.frame = middlePosition;
                    }, completion: {finished in
                        UIView.animateWithDuration(completeDuration/5, delay: completeDuration*(3/5), options: UIViewAnimationOptions.CurveEaseIn, animations: {
                            toAnimate.frame = CGRectMake(containerView.frame.width+50, middlePosition.origin.y, middlePosition.width , middlePosition.height)
                            }, completion :
                            finalComplention
                        )}
                )
            }
        }
    }
    
    class Imaging{
        static func cropImage(image: UIImage, cropRect: CGRect) -> UIImage{
            var imageRef : CGImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect)
            let img : UIImage = UIImage(CGImage: imageRef)!
            return img
        }
        
        static func screenShot(view: UIView, cropRect : CGRect?) -> UIImage{
            UIGraphicsBeginImageContext(view.frame.size)
            view.layer.renderInContext(UIGraphicsGetCurrentContext())
            var image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
//            var postImage = UIImage(named: "\(image)")
            
            if let rect = cropRect{
                image = UtilityFunction.Imaging.cropImage(image, cropRect: rect)
            }
            return image
        }
    }
    
    
    
    
    
}