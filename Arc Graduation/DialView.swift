//
//  View.swift
//  Arc Graduation
//
//  Created by Hamish Knight on 11/03/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class DialView: UIView {
    
    private let semiCircleLayer = CAShapeLayer() // the main arc shape layer
    private let graduationLayer = CAShapeLayer() // the graduation layer that'll display the graduation
    private let graduationTextLayer = CATextLayer() // the layer that renders the text at the end of the graduation
    
    private let graduationWidth = CGFloat(4.0) // the width of the graduation
    private let graduationLength = CGFloat(50.0) // the length of the graduation
    private let graduationTextPadding = CGFloat(5.0) // the padding between the graduation line and the text
    private let graduationColor = UIColor.redColor() // the color of both the graduation line and text
    private let graduationTextFont = UIFont.systemFontOfSize(20) // the font of the text to render at the end of the graduation
    
    /// the starting radius of the graduation
    private var startGradRad:CGFloat {
        get {
            return radius-semiCircleLayer.lineWidth*0.5
        }
    }
    
    /// the ending radius of the graduation
    private var endGradRad:CGFloat {
        get {
            return startGradRad+graduationLength
        }
    }
    
    /// radius of your arc
    private var radius:CGFloat {
        get {
            return self.frame.size.width*0.5 - 100.0
        }
    }
    
    /// center point of your arc
    private var centerPoint:CGPoint {
        get {
            return CGPoint(x: self.frame.size.width*0.5 , y: self.frame.size.height)
        }
    }
    
    /// default paragraph style
    private lazy var paragraphStyle:NSParagraphStyle = {
        return NSParagraphStyle()
    }()
    
    /// the text attributes dictionary. used to obtain a size of the drawn text in order to calculate its frame
    private lazy var textAttributes:[String:AnyObject] = {
        return [NSParagraphStyleAttributeName:self.paragraphStyle, NSFontAttributeName:self.graduationTextFont]
    }()
    
    /// the angle of the graduation
    var graduationAngle:CGFloat = 0 {
        didSet {
            updateGraduationAngle() // update graduation
        }
    }
    
    override var frame: CGRect {
        didSet {
            semiCircleLayer.frame = CGRect(origin: CGPointZero, size: frame.size)
            
            // drawing an upper half of a circle -> 180 degree to 0 degree, clockwise
            let startAngle = CGFloat(M_PI)
            let endAngle = CGFloat(0.0)
            
            // path set here
            let semiCirclePath = UIBezierPath(arcCenter:centerPoint, radius:radius, startAngle:startAngle, endAngle:endAngle, clockwise: true)
            semiCircleLayer.path = semiCirclePath.CGPath
            
            graduationLayer.frame = semiCircleLayer.bounds
            updateGraduationAngle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSemiCircle()
        addGraduation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addSemiCircle() {
        
        // layer customisation
        semiCircleLayer.fillColor = UIColor.clearColor().CGColor
        semiCircleLayer.strokeColor = UIColor(red: 237.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0).CGColor
        semiCircleLayer.lineWidth = 20.0
        semiCircleLayer.lineCap = kCALineCapButt
        layer.addSublayer(semiCircleLayer)
    }
    
    func addGraduation() {
        
        // configure stroking options
        graduationLayer.fillColor = UIColor.clearColor().CGColor
        graduationLayer.strokeColor = graduationColor.CGColor
        graduationLayer.lineWidth = graduationWidth
        semiCircleLayer.addSublayer(graduationLayer)
        
        graduationTextLayer.contentsScale = UIScreen.mainScreen().scale // to ensure the text is rendered at the screen scale
        graduationTextLayer.font = graduationTextFont
        graduationTextLayer.fontSize = graduationTextFont.pointSize // required as CATextLayer ignores the font size of the font you pass
        graduationTextLayer.foregroundColor = graduationColor.CGColor // color of text
        graduationLayer.addSublayer(graduationTextLayer)
        
        updateGraduationAngle()
    }
    
    func updateGraduationAngle() {
        
        // the starting point of the graduation line. the angles are negative as the arc is effectively drawn upside-down in the UIKit coordinate system.
        let startGradPoint = CGPoint(x: cos(-graduationAngle)*startGradRad+centerPoint.x, y: sin(-graduationAngle)*startGradRad+centerPoint.y)
        let endGradPoint = CGPoint(x: cos(-graduationAngle)*endGradRad+centerPoint.x, y: sin(-graduationAngle)*endGradRad+centerPoint.y)
        
        // the path for the graduation line
        let graduationPath = UIBezierPath()
        graduationPath.moveToPoint(startGradPoint) // start point
        graduationPath.addLineToPoint(endGradPoint) // end point
        
        graduationLayer.path = graduationPath.CGPath // add path to the graduation shape layer
        
        // the text to render at the end of the graduation - do you custom value logic here
        let str : NSString = "value"
        
        // size of the rendered text
        let textSize = str.sizeWithAttributes(textAttributes)
        
        let xOffset = abs(cos(graduationAngle))*textSize.width*0.5 // the x-offset of the text from the end of the graduation line
        let yOffset = abs(sin(graduationAngle))*textSize.height*0.5 // the y-offset of the text from the end of the graduation line
        
        // bit of pythagorus to determine how far away the center of the text lies from the end of the graduation line. multiplying the values together is cheaper than using pow.
        let textOffset = sqrt(xOffset*xOffset+yOffset*yOffset)+graduationTextPadding
        
        // the center of the text to render
        let textCenter = CGPoint(x: cos(-graduationAngle)*textOffset+endGradPoint.x, y: sin(-graduationAngle)*textOffset+endGradPoint.y)
        
        // the frame of the text to render
        let textRect = CGRect(x: textCenter.x-textSize.width*0.5, y: textCenter.y-textSize.height*0.5, width: textSize.width, height: textSize.height)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        graduationTextLayer.frame = textRect
        CATransaction.commit()
        
        graduationTextLayer.string = str
    }
}
