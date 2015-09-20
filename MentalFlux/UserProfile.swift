//
//  UserProfile.swift
//  MentalFlux
//
//  Created by Blair Altland on 9/18/15.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import Foundation


class UserProfile {
    
    
    //Variables
        //create dictionary
    var userDictionary = [String: Int]()
    var tally: Int
    var result: Int
    var questionType:String
    let questionKey = ""
    var questionID: AnyObject = 101

    
    init() {
        tally = 0
        userDictionary = ["":tally]
        result = 0
        questionType = ""
    }
    
    func calculateResults(results: Int, question:String) ->Int
    {
        let results = result
        let question = questionType
        tally += results
        userDictionary[question] = tally
        return userDictionary[question]!
    }
    
    

    func storeData(question:String, value:Int)
    {
            questionType = question
            userDictionary[question] = value
        
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDirectory = paths.objectAtIndex(0) as! NSString
            let path = documentsDirectory.stringByAppendingPathComponent("UserProfile.plist")
            
            var dict: NSMutableDictionary = ["Key": "ID"]
            //saving values
            dict.setObject(questionID, forKey: questionKey)
            //...
            
            //writing plist
            dict.writeToFile(path, atomically: false)
            
            let resultDictionary = NSMutableDictionary(contentsOfFile: path)
            //check to see if it is working correctly
            print("plist contains \(resultDictionary?.description)")
        
        
    }
    

}