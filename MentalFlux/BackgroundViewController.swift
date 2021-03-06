//
//  ViewController.swift
//  RadarChartTest1
//
//  Created by Andrew J Clark on 2/10/2015.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import UIKit
import CoreText

class BackgroundViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get scores out of Userprofile
    override func viewWillAppear(animated: Bool) {
        
    }
}


func backGroundPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat)->[CGPoint] {
    let angle = degree2radian(360/CGFloat(sides))
    let cx = x
    let cy = y
    let r  = radius
    var i = 0
    var points = [CGPoint]()
    while i <= sides {
        let xpo = cx + r * cos(angle * CGFloat(i))
        let ypo = cy + r * sin(angle * CGFloat(i))
        points.append(CGPoint(x: xpo, y: ypo))
        i++;
    }
    return points
}


func polygonPath(x x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int) -> CGPathRef {
    let path = CGPathCreateMutable()
    let points = backGroundPointArray(sides, x: x, y: y,radius: radius)
    let cpg = points[0]
    CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
    for p in points {
        CGPathAddLineToPoint(path, nil, p.x, p.y)
    }
    CGPathCloseSubpath(path)
    return path
}


func drawBackgroundLayer(x x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) -> CAShapeLayer {
    let shape = CAShapeLayer()
    shape.path = polygonPath(x: x, y: y, radius: radius, sides: sides)
    shape.fillColor = color.CGColor
    return shape
}

