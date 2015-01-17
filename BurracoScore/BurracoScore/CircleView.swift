//
//  CircleView.swift
//  BurracoScore
//
//  Created by Iacopo on 17/01/15.
//  Copyright (c) 2015 YeApp. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    struct puntiCirconferenza
    {
        var puntiBaseX : [CGFloat];
        var puntiBaseY : [CGFloat];
        
        var subPuntiBaseX : [CGFloat]
        var subPuntiBaseY : [CGFloat]
        init(){
            puntiBaseX = []
            puntiBaseY = []
            subPuntiBaseX = []
            subPuntiBaseY = []
        }
        
        mutating func addPointXY(pointX : CGFloat, pointY : CGFloat){
            puntiBaseX.append(pointX)
            puntiBaseY.append(pointY)
        }
        
        mutating func addSubPointXY(pointX: CGFloat, pointY: CGFloat){
            subPuntiBaseY.append(pointY)
            subPuntiBaseX.append(pointX)
        }
        
        func getPointXY(position: Int) -> (CGFloat, CGFloat)?{
            if(!puntiBaseX.isEmpty){
                return (puntiBaseX[position], puntiBaseY[position])
            }else{
                return nil
            }
        }
        
        func getSubPointXY(position:Int) -> (CGFloat, CGFloat)?{
            
            if(!subPuntiBaseX.isEmpty){
                return (subPuntiBaseX[position], subPuntiBaseY[position])
            }else{
                return nil
            }
        }
    }
    
    let offsetCircle: CGFloat = 40
    let precision: Int = 5
    let maxValueTick: Int = 270
    let pi : Int = 180
    let pi2 : Int = 360
    
    var puntiCerchio = puntiCirconferenza()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        calcolaPuntiBase(frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder )
        calcolaPuntiBase(frame)
    }
    
    override func drawRect(rect: CGRect) {
        
        let canvas = UIGraphicsGetCurrentContext()
        
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        let width = frame.size.width
        let height = frame.size.height
        
        CGContextMoveToPoint(canvas, 0, centerY)
        CGContextAddLineToPoint(canvas, width, height/2)
        CGContextStrokePath(canvas)
        CGContextMoveToPoint(canvas, width/2, 0)
        CGContextAddLineToPoint(canvas, width/2, height)
        CGContextStrokePath(canvas)
        //        drawExternalCircle(canvas, sizeX: width, sizeY: height)
        drawLinee(canvas)
    }
    
    final func calcolaPuntiBase(frame: CGRect){
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        let r = CGFloat((frame.size.width-offsetCircle)/2)
        for index in (0...(maxValueTick/precision)){
            let angolo = (CGFloat)(pi2 * (index * precision)) / CGFloat(M_PI*2)
            let puntoX = centerX + (r * cos(CGFloat((Double((index * precision)+160)/(Double(pi*M_PI))))))
            let puntoY = centerY + (r * sin(CGFloat((Double((index * precision)+160)/(Double(pi*M_PI))))))
            puntiCerchio.addPointXY(puntoX, pointY: puntoY)
        }
        
        for index in (0...(maxValueTick/precision)){
            let angolo = (CGFloat)(360 * (index * precision)) / CGFloat(M_PI*2)
            let puntoX = centerX + ((r-10) * cos(CGFloat((Double((index * precision)+160))/180*M_PI)))
            let puntoY = centerY + ((r-10) * sin(CGFloat((Double((index * precision)+160))/180*M_PI)))
            puntiCerchio.addSubPointXY(puntoX, pointY: puntoY)
        }
        
        
    }
    
    private func drawLinee(canvas: CGContext){
        for index in (0...(maxValueTick/precision)){
            puntiCerchio.getPointXY(index)
            CGContextMoveToPoint(canvas, puntiCerchio.getPointXY(index)!.0, puntiCerchio.getPointXY(index)!.1)
            CGContextAddLineToPoint(canvas, puntiCerchio.getSubPointXY(index)!.0, puntiCerchio.getSubPointXY(index)!.1)
            CGContextStrokePath(canvas)
            
        }
    }
    
    private func drawExternalCircle(canvas: CGContext, sizeX: CGFloat , sizeY: CGFloat ) {
        CGContextAddArc(canvas, sizeX/2, sizeY/2, (sizeX-offsetCircle)/2, CGFloat(M_PI*(8/9)), CGFloat(M_PI*(1/9)),0)
        CGContextStrokePath(canvas)
    }
    
    
    
}
