//
//  ViewController.swift
//  RadarChartTest1
//
//  Created by Andrew J Clark on 2/10/2015.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var chartView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        
        let currentScores = UserProfile.sharedProfile.currentScores()
        
        var scoreArray:[Int] = []
        
        var highestScore = 0
        
        for (key, score) in currentScores {
            
            print(key)
            print(score)
            
            scoreArray.append(score)
            
            if score > highestScore {
                highestScore = score
            }
        }
        
//        var count = 0
//        for index in 1...8 {
//
//            //            scoreArray.append(score)
//
//            count += 1
//            
//            scoreArray.append(index)
//            
//            if count > highestScore {
//                highestScore = count
//            }
//            
//        }
        
        if let viewToRemove = chartView {
            viewToRemove.removeFromSuperview()
        }
        
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        
        let radius:CGFloat = CGRectGetWidth(newView.frame) / CGFloat(4) / CGFloat(highestScore)
        
        let polyLayer = drawPolygonLayer(CGRectGetMidX(newView.frame),y: CGRectGetMidY(newView.frame),radius: radius, scores: scoreArray, color: UIColor.redColor())
        
        newView.layer.addSublayer(polyLayer)
        self.view.addSubview(newView)
        
        chartView = newView
    }
}


func degree2radian(a:CGFloat)->CGFloat {
    let b = CGFloat(M_PI) * a/180
    return b
}


func polygonPointArrayForScores(scores:Array<Int>,x:CGFloat,y:CGFloat,radius:CGFloat)->[CGPoint] {
    print("polygonPointArrayForScores")
    
    let sides = scores.count;
    
    let angle = degree2radian(360/CGFloat(sides))
    let cx = x // x origin
    let cy = y // y origin
    let r  = radius // radius of circle
    var i = 0
    var points = [CGPoint]()
    
    for score in scores {
        
        let floatScore = CGFloat(score) + 2 // Middle buffer
        
        let xpo = cx + (r * floatScore) * cos(angle * CGFloat(i))
        let ypo = cy + (r * floatScore) * sin(angle * CGFloat(i))
        points.append(CGPoint(x: xpo, y: ypo))
        i++;
    }
    
    return points
}


func polygonPath(x:CGFloat, y:CGFloat, radius:CGFloat, scores:Array<Int>) -> CGPathRef {
    let path = CGPathCreateMutable()
    
    let points = polygonPointArrayForScores(scores, x: x, y: y, radius: radius)
    let cpg = points[0]
    
    CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
    for p in points {
        CGPathAddLineToPoint(path, nil, p.x, p.y)
    }
    CGPathCloseSubpath(path)
    return path
}


func drawPolygonLayer(x:CGFloat, y:CGFloat, radius:CGFloat, scores:Array<Int>, color:UIColor) -> CAShapeLayer {
    
    let shape = CAShapeLayer()
    shape.path = polygonPath(x, y: y, radius: radius, scores: scores)
    shape.strokeColor = color.CGColor
    shape.lineWidth = 5.0
    
    return shape
}
