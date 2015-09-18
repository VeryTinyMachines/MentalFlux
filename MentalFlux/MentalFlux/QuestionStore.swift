//
//  QuestionStore.swift
//  MentalFlux
//
//  Created by Blair Altland on 9/14/15.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import Foundation

class questionRandomizer {
    
    func randomize() -> (AnyObject, AnyObject)
    {
        //dictionary variable
        var questionDictionary: NSDictionary?
        
        var question: AnyObject?
        var randomValue: AnyObject?
        var randomKey: AnyObject?
        
        if let path = NSBundle.mainBundle().pathForResource("QuestionSet", ofType: "plist")
            
        {
            questionDictionary = NSDictionary(contentsOfFile: path)
            
        }
        
        //questionDictionary is now holding the plist
        
        if case let dictionary as Dictionary<String, String> = questionDictionary
        {
            
            let index: Int = Int(arc4random_uniform(UInt32(dictionary.count)))
            let value = Array(dictionary.values)[index]
            let key = Array(dictionary.keys)[index]
            //let value = dictionary[key]
            randomKey = key
            randomValue = value
        }
        
        return (randomKey!, randomValue!)
        
    }
    
}