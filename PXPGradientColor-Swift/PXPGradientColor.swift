//
//  PXPGradientColor.swift
//  PXPGradientColorSampleSwift
//
//  Created by Louka Desroziers on 10/06/2014.
//  Copyright (c) 2014 PixiApps. All rights reserved.
//

import Foundation
import UIKit

class PXPGradientColor
{
    let colorSpace: PXPColorSpace!
    let gradientRef: CGGradient!
    
    class func createGradientRefUsing(colors: [UIColor]!, locations: [CGFloat]?, colorSpaceRef: CGColorSpace!) -> CGGradient {
    
        var cfLocations: ConstUnsafePointer<CGFloat> = nil
        if locations? != nil {
            cfLocations = ConstUnsafePointer(locations!)
        }
        
        let colorsAsObjCArray: NSArray = colors.bridgeToObjectiveC()
        let cgColorsAsObjCArray: NSMutableArray = NSMutableArray(capacity: colorsAsObjCArray.count)
        for color: AnyObject in colorsAsObjCArray {
            assert(color.isKindOfClass(UIColor), "You must provide UIColor objects")
            if color.isKindOfClass(UIColor) {
                cgColorsAsObjCArray.addObject(color.CGColor)
            }
        }

        return CGGradientCreateWithColors(colorSpaceRef, cgColorsAsObjCArray, cfLocations)
    }
    
    /** Initializes a PXPGradientColor object with given UIColors, locations, colorSpace. If no colorSpace provided, a deviceRGBColorSpace is used instead. If no locations provided, CGGradient automatically splits the colors by itself */
    init(colors: [UIColor]!, locations: [CGFloat]?, colorSpace: PXPColorSpace?) {
        self.colorSpace = (colorSpace ? colorSpace! : PXPColorSpace.deviceRGBColorSpace())
        self.gradientRef = PXPGradientColor.createGradientRefUsing(colors, locations: locations, colorSpaceRef: self.colorSpace.colorSpaceRef)
        println(self.gradientRef)
    }
    
    convenience init() {
        println("Lulz, using PXPGradientColor with a default gradient from black to white, enjoy!")
        self.init(colors: [UIColor.blackColor(), UIColor.whiteColor()], locations: nil, colorSpace: PXPColorSpace.deviceGrayColorSpace())
    }
    
    convenience init(startingColor: UIColor!, endingColor: UIColor!) {
        self.init(colors: [startingColor, endingColor], locations: nil, colorSpace: nil)
    }
    convenience init(colors: [UIColor]!) {
        self.init(colors: colors, locations: nil, colorSpace: nil)
    }
    
    @final func scopedAngle(angle: Double) -> Double {
        return fmod(angle, 360)
    }
    
    // ##Credits goes to Cocotron
    @final func retrieveStartAndEndPoints(inout startPoint: CGPoint, inout endPoint: CGPoint, usingAngle angle: Double, inRect rect: CGRect) {
        
        var start:CGPoint, end:CGPoint
        var tanSize: CGPoint
        
        let scopedAngle: Double = self.scopedAngle(angle)
        let positiveAngle: Double = (scopedAngle < 0 ? 360.0 - fabs(scopedAngle) : fabs(scopedAngle))
        
        start = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect))
        tanSize = CGPoint(x: CGRectGetWidth(rect), y: CGRectGetHeight(rect))

        switch positiveAngle {
        case 90..<180 :
            start.x = CGRectGetMaxX(rect)
            tanSize.x = -CGRectGetWidth(rect)
        case 180..<270 :
            start = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
            tanSize = CGPoint(x: -CGRectGetWidth(rect), y: -CGRectGetHeight(rect))
        case 270..<360:
            start.y = CGRectGetMaxY(rect)
            tanSize.y = -CGRectGetHeight(rect)
        default:break
        }
        
        let radAngle: Double = positiveAngle / 180 * M_PI
        let square: Double = sqrt(Double(CGRectGetWidth(rect)) * Double(CGRectGetWidth(rect)) + Double(CGRectGetHeight(rect)) * Double(CGRectGetHeight(rect)))
        let distanceToEnd: Double = cos(atan2(Double(tanSize.y), Double(tanSize.x)) - radAngle) * square

        end = CGPoint(x: CGFloat(cos(radAngle) * distanceToEnd) + start.x, y: CGFloat(sin(radAngle) * distanceToEnd) + start.y)
        
        startPoint = start; endPoint = end
    }
    // ##End of Credits

    func draw(inRect rect: CGRect, angle: Double) {
        self.draw(inBezierPath: UIBezierPath(rect: rect), angle: angle)
    }
    
    func draw(inBezierPath bezierPath: UIBezierPath!, angle: Double) {
        let ctx: CGContext = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        CGContextAddPath(ctx, bezierPath.CGPath)
        CGContextClip(ctx)
        
        var startPoint: CGPoint = CGPointZero
        var endPoint: CGPoint = CGPointZero
        self.retrieveStartAndEndPoints(&startPoint, endPoint: &endPoint, usingAngle: angle, inRect: bezierPath.bounds)
        
        CGContextDrawLinearGradient(ctx, self.gradientRef, startPoint, endPoint, 0)
        CGContextRestoreGState(ctx);
    }
    
}