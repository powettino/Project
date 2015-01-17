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
        var overPuntiBaseX : [CGFloat];
        var overPuntiBaseY : [CGFloat];
        
        var puntiBaseX : [CGFloat];
        var puntiBaseY : [CGFloat];
        
        var underPuntiBaseX : [CGFloat]
        var underPuntiBaseY : [CGFloat]
        init(){
            puntiBaseX = []
            puntiBaseY = []
            overPuntiBaseX = []
            overPuntiBaseY = []
            underPuntiBaseX = []
            underPuntiBaseY = []
        }
        
        mutating func addPointXY(x pointX : CGFloat,y pointY : CGFloat){
            puntiBaseX.append(pointX)
            puntiBaseY.append(pointY)
        }
        
        mutating func addUnderPointXY(x pointX: CGFloat,y pointY: CGFloat){
            underPuntiBaseY.append(pointY)
            underPuntiBaseX.append(pointX)
        }
        
        mutating func addOverPointXY(x pointX: CGFloat,y pointY: CGFloat){
            overPuntiBaseY.append(pointY)
            overPuntiBaseX.append(pointX)
        }
        
        func getPointXY(position: Int) -> (CGFloat, CGFloat){
            return (puntiBaseX[position], puntiBaseY[position])
        }
        
        func getOverPointXY(position:Int) -> (CGFloat, CGFloat){
            
            return (overPuntiBaseX[position], overPuntiBaseY[position])
            
        }
        
        func getUnderPointXY(position:Int) -> (CGFloat, CGFloat){
            
            return (underPuntiBaseX[position], underPuntiBaseY[position])
            
        }
    }
    
    let offsetCircle: CGFloat = 40
    let precision: CGFloat = ((1/36)*CGFloat(M_PI))
    let maxValueTick: CGFloat = ((4/3)*CGFloat(M_PI))
    let pi : CGFloat = CGFloat(M_PI)
    let pi2 : CGFloat = (2*CGFloat(M_PI))
    let offsetAngle : CGFloat = (5/6) * CGFloat(M_PI)
    var externalRadius:CGFloat = 0
    var radius : CGFloat = 0
    var internalRadius:CGFloat = 0
    var minRadius:CGFloat = 0
    var centerX: CGFloat = 0
    var centerY:CGFloat = 0
    var tickerAngle: CGFloat = 0
    let tickerAnglePlus : CGFloat = (1/18) * CGFloat(M_PI)
    var multiplier: CGFloat = 1
    
    var puntiCerchio = puntiCirconferenza()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        calcolaPuntiBase(frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder )
        calcolaPuntiBase(frame)
    }
    
    private func drawTicker(inCanvas canvas: CGContext)
    {
        CGContextSaveGState(canvas)
        
        CGContextSetStrokeColorWithColor(canvas, UIColor.blackColor().CGColor)
        CGContextSetFillColorWithColor(canvas, UIColor.grayColor().CGColor)
        
        CGContextMoveToPoint(canvas, centerX, centerY)
        let puntoXCircle = centerX + (radius * cos((tickerAngle)))
        let puntoYCircle = centerY + (radius * sin((tickerAngle)))
        var punti = findXY(radius, centerX: centerX, centerY: centerY, angle: tickerAngle)
        CGContextAddLineToPoint(canvas, punti.0, punti.1)
        
        
        var puntoX = centerX + (minRadius * cos((1/4)*pi))
        var puntoY = centerY + (minRadius * sin((1/4)*pi))
        punti = findXY(minRadius, centerX: centerX, centerY: centerY, angle: tickerAngle-((1/2)*pi))
        CGContextAddLineToPoint(canvas, punti.0, punti.1)
        CGContextAddLineToPoint(canvas, centerX, centerY)
        
        CGContextDrawPath(canvas, kCGPathFillStroke)
        
        CGContextSetFillColorWithColor(canvas, UIColor.lightGrayColor().CGColor)
        CGContextMoveToPoint(canvas, centerX, centerY)
        CGContextAddLineToPoint(canvas, puntoXCircle, puntoYCircle)
        puntoX = centerX + (minRadius * cos((5/4)*pi))
        puntoY = centerY + (minRadius * sin((5/4)*pi))
        punti = findXY(minRadius, centerX: centerX, centerY: centerY, angle: tickerAngle+((1/2)*pi))
        CGContextAddLineToPoint(canvas, punti.0, punti.1)
        CGContextAddLineToPoint(canvas, centerX, centerY)
        CGContextDrawPath(canvas, kCGPathFillStroke)
        CGContextRestoreGState(canvas)
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
        drawExternalCircle(canvas, sizeX: width, sizeY: height)
        drawLinee(canvas)
        drawTicker(inCanvas: canvas)
        drawCenterCircle(canvas, sizeX: width, sizeY: height)
    }
    
    final func calcolaPuntiBase(frame: CGRect){
        self.radius = (frame.size.width-offsetCircle)/2
        self.externalRadius = radius + 3
        self.internalRadius = externalRadius-10
        self.minRadius = internalRadius-(radius*(5/6))
        centerX = frame.size.width/2
        centerY = frame.size.height/2
        tickerAngle = offsetAngle
        for index in (0...Int(maxValueTick/precision)){
            let puntoX = centerX + (radius * cos((CGFloat(index) * precision)+offsetAngle))
            let puntoY = centerY + (radius * sin((CGFloat(index) * precision)+offsetAngle))
            var punti = findXY(radius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addPointXY(x: punti.0, y: punti.1)
            let underPuntoX = centerX + (internalRadius * cos((CGFloat(index) * precision)+offsetAngle))
            let underPuntoY = centerY + (internalRadius * sin((CGFloat(index) * precision)+offsetAngle))
            punti = findXY(internalRadius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addUnderPointXY(x: punti.0, y: punti.1)
            let overPuntoX = centerX + (externalRadius * cos((CGFloat(index) * precision)+offsetAngle))
            let overPuntoY = centerY + (externalRadius * sin((CGFloat(index) * precision)+offsetAngle))
            punti = findXY(externalRadius, centerX: centerX, centerY: centerY, angle: (CGFloat(index)*precision)+offsetAngle)
            puntiCerchio.addOverPointXY(x: punti.0, y: punti.1)
            
        }
    }
    
    func setnewTickerAngle(newAngle angle: CGFloat){
        if(angle>=maxValueTick){
            
        }else{
            tickerAngle = angle;
            
            self.setNeedsDisplay()
            println("ciaoi")
        }
    }
    
    func addTickerAngle() -> Void{
        if( multiplier > 0){
            if((tickerAngle + (tickerAnglePlus * multiplier)) <= (maxValueTick + offsetAngle)){
                tickerAngle += tickerAnglePlus * multiplier
                self.setNeedsDisplay()
                println("ciaoi")
            }else{
                tickerAngle = maxValueTick + offsetAngle
                multiplier = -1
            }
        }else{
            if((tickerAngle + (tickerAnglePlus * multiplier)) >= offsetAngle){
                tickerAngle += tickerAnglePlus * multiplier
                self.setNeedsDisplay()
                println("ciaoi")
            }else{
                tickerAngle = offsetAngle
                multiplier = 1
            }
        }
    }
    
    func getTickerAngle() -> CGFloat{
        return tickerAngle
    }
    
    private func drawLinee(canvas: CGContext){
        CGContextSaveGState(canvas)
        for index in (0...Int(maxValueTick/precision)){
            if(index % 4 == 0){
                CGContextSetStrokeColorWithColor(canvas, UIColor.redColor().CGColor)
            }else{
                CGContextSetStrokeColorWithColor(canvas, UIColor.whiteColor().CGColor)
            }
            CGContextSetLineWidth(canvas, 2.0);
            CGContextMoveToPoint(canvas, puntiCerchio.getOverPointXY(index).0, puntiCerchio.getOverPointXY(index).1)
            CGContextAddLineToPoint(canvas, puntiCerchio.getUnderPointXY(index).0, puntiCerchio.getUnderPointXY(index).1)
            CGContextStrokePath(canvas)
        }
        CGContextRestoreGState(canvas)
    }
    
    private func drawExternalCircle(canvas: CGContext, sizeX: CGFloat , sizeY: CGFloat ) {
        CGContextSaveGState(canvas)
        CGContextAddArc(canvas, centerX, centerY, radius, offsetAngle, offsetAngle + (maxValueTick),0)
        var punti = findXY(radius, centerX: centerX, centerY: centerY, angle: offsetAngle)
        CGContextAddLineToPoint(canvas, punti.0, punti.1)
        CGContextSetFillColorWithColor(canvas, UIColor.blackColor().CGColor)
        CGContextFillPath(canvas)
    }
    
    private func drawCenterCircle(canvas :CGContext, sizeX: CGFloat, sizeY: CGFloat){
        CGContextSetFillColorWithColor(canvas, UIColor.brownColor().CGColor)
        CGContextAddArc(canvas, centerX, centerY, minRadius, offsetAngle, pi2 + (maxValueTick),0)
        CGContextFillPath(canvas)
        CGContextRestoreGState(canvas)
        
    }
    private func findXY(radius : CGFloat, centerX : CGFloat, centerY:CGFloat, angle:CGFloat) -> (CGFloat, CGFloat){
        let puntoX = centerX + (radius * cos(angle))
        let puntoY = centerY + (radius * sin(angle))
        return ( puntoX, puntoY)
    }
    
    
    
}
