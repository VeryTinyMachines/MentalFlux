//
//  ViewController.swift
//  RadarChartTest1
//
//  Created by Andrew J Clark on 2/10/2015.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import UIKit
import CoreText



class GraphViewController: UIViewController {
    
    var chartView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //2 creates new view with center point(X,Y) width and height
        let backView = UIView(frame: CGRect(x: 2, y: 50, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        
        //4
        let backPolyLayer = drawBackgroundLayer(x: CGRectGetMidX(backView.frame),y: CGRectGetMidY(backView.frame),radius: CGRectGetWidth(backView.frame)/2.9, sides: 8, color: UIColor.grayColor())
        //5
        backView.layer.addSublayer(backPolyLayer)
        self.view.addSubview(backView)
        
        /////////////////////////////////////////////////////////////
        //2 creates new view with center point(X,Y) width and height
        let bufferView = UIView(frame: CGRect(x: 2, y: 50, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        
        //4
        let bufferPolyLayer = drawBufferLayer(x: CGRectGetMidX(bufferView.frame),y: CGRectGetMidY(bufferView.frame),radius: CGRectGetWidth(bufferView.frame)/25, sides: 8, color: UIColor.blackColor())
        //5
        bufferView.layer.addSublayer(bufferPolyLayer)
        self.view.addSubview(bufferView)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get scores out of Userprofile
    override func viewWillAppear(animated: Bool) {
        //print("viewWillAppear")
        
        let currentScores = UserProfile.sharedProfile.currentScores()
        
        var scoreArray:[Int] = []
        
        var highestScore = 0
        
        var labelArray:[String] = []
        
        for (key, score) in currentScores {
            
            labelArray.append(key)
        }
        
        for (key, score) in currentScores {
            
            print(key)
            print(score)
            
            scoreArray.append(score)
            
            if score > highestScore {
                highestScore = score
            }
        }
        //
        //

        //
        //
        
        //1 clear the view
        if let viewToRemove = chartView {
            viewToRemove.removeFromSuperview()
        }
        
        //2 creates new view with center point(X,Y) width and height
        let newView = UIView(frame: CGRect(x: 2, y: 50, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        
        // 3 creates radius based on New View and HighScore
        let radius:CGFloat = CGRectGetWidth(newView.frame) / CGFloat(4) / CGFloat(highestScore)
        
        //4
        let polyLayer = drawPolygonLayer(CGRectGetMidX(newView.frame),y: CGRectGetMidY(newView.frame),radius: radius, scores: scoreArray, color: UIColor.redColor())
        //5
        newView.layer.addSublayer(polyLayer)
        self.view.addSubview(newView)
        
        chartView = newView
        
    }    
}

// 6 convert
func degree2radian(a:CGFloat)->CGFloat {
    let b = CGFloat(M_PI) * a/180
    return b
}

// 7 use scores from userprofile to
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
        
        //create buffer zone
        let floatScore = CGFloat(score) + 2 // Middle buffer
        
        let xpo = cx + (r * floatScore) * cos(angle * CGFloat(i))
        let ypo = cy + (r * floatScore) * sin(angle * CGFloat(i))
        //marks center point
        points.append(CGPoint(x: xpo, y: ypo))
        i++;
    }
    
    return points
}


// 8 creates the path to be followed
func polygonPath(x:CGFloat, y:CGFloat, radius:CGFloat, scores:Array<Int>) -> CGPathRef {
    let path = CGPathCreateMutable()
    
    let points = polygonPointArrayForScores(scores, x: x, y: y, radius: radius)
    let cpg = points[0]
    
    CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
    for p in points {
        CGPathAddLineToPoint(path, nil, p.x, p.y)
        //

    }
    CGPathCloseSubpath(path)
    return path
}

// 9 create the object
func drawPolygonLayer(x:CGFloat, y:CGFloat, radius:CGFloat, scores:Array<Int>, color:UIColor) -> CAShapeLayer {
    
    let shape = CAShapeLayer()
    shape.path = polygonPath(x, y: y, radius: radius, scores: scores)
    shape.strokeColor = color.CGColor
    shape.fillColor = UIColor.clearColor().CGColor
    shape.lineWidth = 5.0
    
    return shape
}

