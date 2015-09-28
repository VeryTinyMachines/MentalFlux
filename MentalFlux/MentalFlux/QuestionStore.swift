//
//  QuestionStore.swift
//  MentalFlux
//
//  Created by Blair Altland on 9/14/15.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import Foundation

class QuestionStore {
    
    static let sharedStore = QuestionStore()
    var questionDict = Dictionary<String, Array<String>>()
    
    func questionSetPlistPath() -> String? {
        return NSBundle.mainBundle().pathForResource("QuestionSet", ofType: "plist")
    }
    
    
    private init() {
        loadPlist()
    }
    
    
    //Load Data
    func loadPlist()
    {
        if let path = questionSetPlistPath() {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, Array<String>>
            {
                for (key, value) in dict {
                    questionDict[key] = value
                }
            }
        } else {
            print("Error: Question Set Plist Path not found", terminator: "\n")
        }
    }
    
    
    func randomQuestionForKey(key:String) -> (String?)
     {
        if let array = questionSetForKey(key) {
            // Array - String
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            
            if randomIndex <= array.count {
                return array[randomIndex]
            }
        }
        return nil;
    }

    
    //input sting containing question type and it will return questions of said type
    func questionSetForKey(key:String) -> Array<String>?
    {
        return questionDict[key]
    }
    
    func returnRandomKey() -> String?
    {
        
        let array = [String](questionDict.keys)
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        
        if randomIndex <= array.count
        {
            return array[randomIndex]
        }
        return nil;
    }
}