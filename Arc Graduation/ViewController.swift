//
//  ViewController.swift
//  Arc Graduation
//
//  Created by Hamish Knight on 11/03/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dialView = DialView()
    var phase = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialView.frame = CGRect(x: 0, y: 100, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.width)
        dialView.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(dialView)
        
        let displayLink = CADisplayLink(target: self, selector: Selector("updateGraduationAngle"))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func updateGraduationAngle() {
        
        if dialView.graduationAngle > CGFloat(M_PI) {
            phase = false
        }
        
        if dialView.graduationAngle < 0 {
            phase = true
        }
        
        if phase {
            dialView.graduationAngle += 0.01
        } else {
            dialView.graduationAngle -= 0.01
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

