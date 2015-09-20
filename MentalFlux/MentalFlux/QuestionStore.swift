//
//  QuestionStore.swift
//  MentalFlux
//
//  Created by Blair Altland on 9/14/15.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import Foundation

class questionRandomizer {
    
    //Variables
    var questionDict: Dictionary<String, Array<String>>
    
    init() {
        questionDict = ["": ["", "", ""]]

    }
    
    //
    let path = NSBundle.mainBundle().pathForResource("QuestionSet", ofType: "plist")
    
    //Load Data
    func loadPlist() -> (AnyObject)
    {
        if let dict = NSDictionary(contentsOfFile: path!) as? Dictionary<String, Array<String>>
        {
            for (key, value) in dict {
                    //print("key: \(key)", appendNewline: true)
                
                        questionDict[key] = [key]
                
                    for string in value
                    {
                        //print("value.string: \(string)", appendNewline: true)
                        
                        questionDict[string] = value
                }
            }
        }
        
        return questionDict
    }
    
    
    func randomize(key:String) -> (String)
     {
        var array = questionDict[key]
        let randomIndex = Int(arc4random_uniform(UInt32(array!ty.count)))
        
        return array[randomIndex]
    }

    
    //input sting containing question type and it will return questions of said type
    func questionType(key:String) -> (Array<String>)!
    {
        //sort dictionary for keys
        
        //question type = key
        //returns string of question type
        return questionDict[key]
    }
    
}