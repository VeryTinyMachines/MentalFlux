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
        
        
        
        // Buffer Zone
        //2 creates new view with center point(X,Y) width and height
        let bufferView = UIView(frame: CGRect(x: 2, y: 50, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        
        
        self.view.addSubview(bufferView)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get scores out of Userprofile
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        
        let currentScores = UserProfile.sharedProfile.currentScores()
        
        print(currentScores)
        
        var highestScore = 0
        
        for (_, score) in currentScores {
            
            if score > highestScore {
                highestScore = score
            }
        }
        
        print(highestScore)
        
        print("2")
        
        //1 clear the view
        if let viewToRemove = chartView {
            viewToRemove.removeFromSuperview()
        }
        
        //2 creates new view with center point(X,Y) width and height
        let newView = UIView(frame: CGRect(x: 2, y: 50, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        
        // 3 creates radius based on New View and HighScore
        
        var radius:CGFloat = 0
        
        if highestScore > 0 {
            radius = CGRectGetWidth(newView.frame) / CGFloat(3) / CGFloat(highestScore)
        }
        
        print("radius: \(radius)")
        
        let x = CGRectGetMidX(newView.frame)
        let y = CGRectGetMidY(newView.frame)
        
        print("3")
        
        // Background octagon.
        let backPolyLayer = drawBackgroundLayer(x: x, y: y,radius: radius * CGFloat(highestScore + 1), sides: 8, color: UIColor.grayColor().colorWithAlphaComponent(0.5))
        //5
        newView.layer.addSublayer(backPolyLayer)
        
        
        // Buffer
        let bufferPolyLayer = drawBufferLayer(x: x,y: y,radius: radius, sides: 8, color: UIColor.blackColor())
        //5
        newView.layer.addSublayer(bufferPolyLayer)
        
        print("4")
        
        let pointKeyDictionary = polygonPointKeyDictionaryForScores(currentScores, x: x, y: y, radius: radius)
        
        var pointArray: [CGPoint] = []
        
        for (key, scoreCo) in pointKeyDictionary {
            
            let scorePoint = pointForScore(CGFloat(scoreCo.score), origin: scoreCo.originPoint, angle: scoreCo.angle, radius: radius)
            pointArray.append(scorePoint)
            
            
            let labelPoint = pointForScore(CGFloat(scoreCo.score) + 1, origin: scoreCo.originPoint, angle: scoreCo.angle, radius: radius)
            
            let rect = CGRect(x: labelPoint.x - 11, y: labelPoint.y - 11, width: 22, height: 22)
            
            
            let keyLabel = UILabel(frame: rect)
            keyLabel.text = key
            keyLabel.textAlignment = NSTextAlignment.Center
            keyLabel.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.25)

            newView.addSubview(keyLabel)
            
            
            // Draw spoke
            let spokePoint = pointForScore(0, origin: scoreCo.originPoint, angle: scoreCo.angle, radius: radius)
            
            
            
            
            let path = CGPathCreateMutable()
            
            
            CGPathMoveToPoint(path, nil, spokePoint.x, spokePoint.y)
            CGPathAddLineToPoint(path, nil, scorePoint.x, scorePoint.y)
            CGPathCloseSubpath(path)
            
            

            let shape = CAShapeLayer()
            shape.path = path
            shape.strokeColor = UIColor.blackColor().CGColor
            shape.fillColor = UIColor.clearColor().CGColor
            shape.lineWidth = 2.0
            
            newView.layer.addSublayer(shape)
            
            
            
        }
        
        print("5")
        
        // Draw our new polygon
        
        let polyPath = polygonPathFromPoints(pointArray)
        
        
        
        let polyLayer = CAShapeLayer()
        polyLayer.path = polyPath
        polyLayer.strokeColor = UIColor.greenColor().CGColor
        polyLayer.fillColor = UIColor.clearColor().CGColor
        polyLayer.lineWidth = 5.0
        
        
        
        print("6")
        
        //4
//        let polyLayer = drawPolygonLayer(x,y: y,radius: radius, scores: scoreArray, color: UIColor.redColor())
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



// 8 creates the path to be followed
func polygonPathFromPoints(points:Array<CGPoint>) -> CGPathRef {
    let path = CGPathCreateMutable()
    
    let cpg = points[0]
    
    CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
    for p in points {
        CGPathAddLineToPoint(path, nil, p.x, p.y)
        
    }
    CGPathCloseSubpath(path)
    return path
}


// 7 use scores from userprofile to
func polygonPointKeyDictionaryForScores(scores: Dictionary<String, Int>,x:CGFloat,y:CGFloat,radius:CGFloat)-> Dictionary<String,ScoreCoordinate> {
    print("polygonPointArrayForScores")
    
    let sides = scores.count;
    
    let angle = degree2radian(360/CGFloat(sides))
    let cx = x // x origin
    let cy = y // y origin
    let r  = radius // radius of circle
    var i = 0
//    var points = [CGPoint]()
    
    var pointKeyDictionary = Dictionary<String, ScoreCoordinate>()
    
    for (key,score) in scores {
        
        let scoreCo = ScoreCoordinate()
        
        scoreCo.originPoint = CGPoint(x: x, y: y)
        scoreCo.score = score
        scoreCo.angle = angle * CGFloat(i)
        
//        let xpo = cx + (r * floatScore) * cos(angle * CGFloat(i))
//        let ypo = cy + (r * floatScore) * sin(angle * CGFloat(i))
        //marks center point
        
//        let point = CGPoint(x: xpo, y: ypo)
        
        pointKeyDictionary[key] = scoreCo
        
        i++;
    }
    
    return pointKeyDictionary
}

func pointForScore(score: CGFloat, origin: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
    
    let floatScore = score + 1
    
    let xpo = origin.x + (radius * floatScore) * cos(angle)
    let ypo = origin.y + (radius * floatScore) * sin(angle)
    
    return CGPoint(x: xpo, y: ypo)
    
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

