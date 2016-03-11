//
//  ViewController.swift
//  Arc Graduation
//
//  Created by Hamish Knight on 11/03/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = DialView(frame: CGRect(x: 0, y: 100, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.width))
        v.backgroundColor = UIColor.lightGrayColor()
        v.graduationAngle = CGFloat(M_PI*0.79) // 21% along the arc from the left (0 degrees coresponds to the right hand side of the circle, with the positive angle direction going anti-clocwise (much like a unit circle in maths), so we define 79% along the arc, from the right hand side)
        view.addSubview(v)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

