//
//  ViewController.swift
//  RadarChartTest1
//
//  Created by Andrew J Clark on 2/10/2015.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import UIKit
import CoreText



class BufferViewController: UIViewController {
    
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

// 7 use scores from userprofile to
func bufferPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat)->[CGPoint] {
    let angle = degree2radian(360/CGFloat(sides))
    let cx = x // x origin
    let cy = y // y origin
    let r  = radius // radius of circle
    var i = 0
    var points = [CGPoint]()
    while i <= sides {
        var xpo = cx + r * cos(angle * CGFloat(i))
        var ypo = cy + r * sin(angle * CGFloat(i))
        points.append(CGPoint(x: xpo, y: ypo))
        i++;
    }
    return points
}

// 8 creates the path to be followed
func bufferPath(x x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int) -> CGPathRef {
    let path = CGPathCreateMutable()
    let points = bufferPointArray(sides, x: x, y: y,radius: radius)
    var cpg = points[0]
    CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
    for p in points {
        CGPathAddLineToPoint(path, nil, p.x, p.y)
    }
    CGPathCloseSubpath(path)
    return path
}

// 9 create the object
func drawBufferLayer(x x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) -> CAShapeLayer {
    
    var shape = CAShapeLayer()
    shape.path = bufferPath(x: x, y: y, radius: radius, sides: sides)
    shape.strokeColor = color.CGColor
    shape.fillColor = UIColor.clearColor().CGColor
    shape.lineWidth = 3.0
    return shape
}