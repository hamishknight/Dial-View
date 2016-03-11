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
    
    /// the color of both the graduation line and text
    var graduationColor = UIColor.redColor() {
        didSet {
            graduationLayer.strokeColor = graduationColor.CGColor // color of graduation line
            graduationTextLayer.foregroundColor = graduationColor.CGColor // color of text
        }
    }
    
    /// the width of the graduation
    var graduationWidth = CGFloat(4.0) {
        didSet {
            graduationLayer.lineWidth = graduationWidth
        }
    }
    
    /// the length of the graduation
    var graduationLength = CGFloat(50.0) {
        didSet {
            updateGraduationAngle()
        }
    }
    
    /// the padding between the graduation line and the text
    var graduationTextPadding = CGFloat(5.0) {
        didSet {
            updateGraduationAngle()
        }
    }
    
    /// the font of the text to render at the end of the graduation
    var graduationTextFont = UIFont.systemFontOfSize(20) {
        didSet {
            textAttributes[NSFontAttributeName] = graduationTextFont
            graduationTextLayer.font = graduationTextFont
            graduationTextLayer.fontSize = graduationTextFont.pointSize
            updateGraduationAngle()
        }
    }
    
    /// the angle of the graduation
    var graduationAngle:CGFloat = 0 {
        didSet {
            updateGraduationAngle() // update graduation
        }
    }
    
    var dialColor:UIColor = UIColor(red: 237.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0) {
        didSet {
            semiCircleLayer.strokeColor = dialColor.CGColor
        }
    }
    
    override var frame: CGRect {
        didSet {
        
            // update semi-circle layer frame
            semiCircleLayer.frame = CGRect(origin: CGPointZero, size: frame.size)
            graduationLayer.frame = semiCircleLayer.bounds
        
            // update semi-circle path
            let semiCirclePath = UIBezierPath(arcCenter:centerPoint, radius:radius, startAngle:CGFloat(M_PI), endAngle:CGFloat(0.0), clockwise: true)
            semiCircleLayer.path = semiCirclePath.CGPath
            
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
    
    private func addSemiCircle() {
        
        // layer customisation
        semiCircleLayer.fillColor = UIColor.clearColor().CGColor
        semiCircleLayer.lineWidth = 20.0
        semiCircleLayer.lineCap = kCALineCapButt
        semiCircleLayer.strokeColor = dialColor.CGColor
        layer.addSublayer(semiCircleLayer)
    }
    
    private func addGraduation() {
        
        // configure stroking options
        graduationLayer.fillColor = UIColor.clearColor().CGColor
        graduationLayer.lineWidth = graduationWidth
        graduationLayer.strokeColor = graduationColor.CGColor // color of graduation line
        semiCircleLayer.addSublayer(graduationLayer)
        
        graduationTextLayer.contentsScale = UIScreen.mainScreen().scale // to ensure the text is rendered at the screen scale
        graduationTextLayer.foregroundColor = graduationColor.CGColor // color of text
        graduationTextLayer.font = graduationTextFont
        graduationTextLayer.fontSize = graduationTextFont.pointSize // required as CATextLayer ignores the font size of the font you pass
        graduationLayer.addSublayer(graduationTextLayer)
        
        updateGraduationAngle()
    }
    
    private func updateGraduationAngle() {
        
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
