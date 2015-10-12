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
    
    var orderedKeyArray:[String] = []
    
    @IBOutlet weak var qLabel: UILabel!
    
    @IBAction func resetButton(sender: AnyObject) {
        UserProfile.sharedProfile.reset()
        updateView()
    }

    var chartView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func resetView() {
        if let viewToRemove = chartView {
            viewToRemove.removeFromSuperview()
        }
    }
    
    
    func insertRadarChart() {
        let currentScores = UserProfile.sharedProfile.currentScores()
        var highestScore = 0
        
        for (_, score) in currentScores {
            if score > highestScore {
                highestScore = score
            }
        }
        
        //2 creates new view with center point(X,Y) width and height
        let newView = UIView(frame: CGRect(x: 2, y: 0, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        
        // 3 creates radius based on New View and HighScore
        
        var radius:CGFloat = 0
        
        if highestScore > 0 {
            
            radius = CGRectGetWidth(newView.frame) / CGFloat(3) / CGFloat(highestScore)
        }
        
        let x = CGRectGetMidX(newView.frame)
        let y = CGRectGetMidY(newView.frame)
        
        // Background octagon.
        let backPolyLayer = drawBackgroundLayer(x: x, y: y,radius: 130, sides: 8, color: UIColor.grayColor().colorWithAlphaComponent(0.5))
        newView.layer.addSublayer(backPolyLayer)
        
        // Buffer
        let bufferPolyLayer = drawBufferLayer(x: x,y: y,radius: 5, sides: 8, color: UIColor.blackColor())
        newView.layer.addSublayer(bufferPolyLayer)
        
        let pointKeyDictionary = polygonPointKeyDictionaryForScores(currentScores, x: x, y: y, radius: radius)
        
        var pointArray: [CGPoint] = []
        
        let keysArray = [String](currentScores.keys)
        orderedKeyArray =  keysArray.sort(<) // TODO - This is ugly and weird to sort in two different places.
        
        for key in orderedKeyArray {
            
            if let scoreCo = pointKeyDictionary[key] {
                
                let scorePoint = pointForScore(CGFloat(scoreCo.score), origin: scoreCo.originPoint, angle: scoreCo.angle, radius: radius)
                pointArray.append(scorePoint)
                
                let labelPoint = pointForScore(CGFloat(scoreCo.score) + 1, origin: scoreCo.originPoint, angle: scoreCo.angle, radius: radius + 0.13)
                
                let rect = CGRect(x: labelPoint.x - 11, y: labelPoint.y - 11, width: 22, height: 22)
                
                // Tap goes here
                let keyButton = UIButton(frame: rect)
                keyButton.setTitle(key, forState: UIControlState.Normal)
                keyButton.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.25)
                
                if let index = orderedKeyArray.indexOf(key) {
                    keyButton.tag = index
}
                
                keyButton.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchDown)
                newView.addSubview(keyButton)
                
                // Draw spoke
                let spokePoint = pointForScore(0, origin: scoreCo.originPoint, angle: scoreCo.angle, radius: 6)
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
        }
        
        // Draw our new polygon
        let polyPath = polygonPathFromPoints(pointArray)
        
        let polyLayer = CAShapeLayer()
        polyLayer.path = polyPath
        polyLayer.strokeColor = UIColor.greenColor().CGColor
        polyLayer.fillColor = UIColor.clearColor().CGColor
        polyLayer.lineWidth = 5.0
        newView.layer.addSublayer(polyLayer)
        
        self.view.addSubview(newView)
        
        chartView = newView
    }
    
    //get scores out of Userprofile
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView() {
        resetView()
        insertRadarChart()
    }
    
    func buttonPressed(sender: UIButton) {
        
        let buttonTag = sender.tag
        let key = orderedKeyArray[buttonTag]
        
        if let intelligenceName = QuestionStore.sharedStore.intelligenceNameForKey(key) {
            qLabel.text = intelligenceName
        } else {
            qLabel.text = "Intelligence name not found"
        }
    }
}


func degree2radian(a:CGFloat)->CGFloat {
    let b = CGFloat(M_PI) * a/180
    return b
}


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


func polygonPointKeyDictionaryForScores(scores: Dictionary<String, Int>,x:CGFloat,y:CGFloat,radius:CGFloat)-> Dictionary<String,ScoreCoordinate> {
    
    let sides = scores.count;
    let angle = degree2radian(360/CGFloat(sides))
    var i = 0
    
    var pointKeyDictionary = Dictionary<String, ScoreCoordinate>()
    
    let keysArray = [String](scores.keys)
    let orderedKeyArray =  keysArray.sort(<)
    
    for key in orderedKeyArray {
        
        if let score = scores[key] {
            
            let scoreCo = ScoreCoordinate()
            scoreCo.originPoint = CGPoint(x: x, y: y)
            scoreCo.score = score
            scoreCo.angle = angle * CGFloat(i)
            pointKeyDictionary[key] = scoreCo
            
            i++;
        }
    }
    
    return pointKeyDictionary
}


func pointForScore(score: CGFloat, origin: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
    
    let floatScore = score + 1
    let xpo = origin.x + (radius * floatScore) * cos(angle)
    let ypo = origin.y + (radius * floatScore) * sin(angle)
    
    return CGPoint(x: xpo, y: ypo)
    
}


func drawBufferLayer(x x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) -> CAShapeLayer {
    
    let shape = CAShapeLayer()
    shape.path = polygonPath(x: x, y: y, radius: radius, sides: sides)
    shape.strokeColor = color.CGColor
    shape.fillColor = UIColor.clearColor().CGColor
    shape.lineWidth = 3.0
    return shape
}

