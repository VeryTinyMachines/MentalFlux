//
//  UserProfile.swift
//  MentalFlux
//
//  Created by Blair Altland on 9/18/15.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

// This class is a singleton that stores the current score per question type for a single user with the ability to increment those values.

import Foundation

class UserProfile {
    
    var userDictionary = [String: Int]()
    
    static let sharedProfile = UserProfile()
    private init() {
        load()
    } //This prevents others from using the default '()' initializer for this class.
    
    
    func currentScoreForKey(key: String) -> Int? {
        
        if let score = userDictionary[key] {
            return score
        }
        
        return nil
    }
    
    
    func updateScoreForKey(key:String, deltaValue: Int) {
        
        if let score = userDictionary[key] {
            let newScore = score + deltaValue
            userDictionary[key] = newScore
        } else {
            // No current score for that key
            // Start a new one
            userDictionary[key] = deltaValue
        }
        save()
    }
    
    
    func currentScores() -> [String: Int] {
        
        var scoreDictionary = [String: Int]()
        scoreDictionary = ["B":0, "IE":0, "IA":0, "L":0, "VE":0, "M":0, "N":0, "VI":0] 
        
        //add values to new dictionary
        for (key, score) in userDictionary {
            
            for (key, value) in scoreDictionary{
            
                scoreDictionary[key] = userDictionary[key]
            }
        }
        
        //if a key has no value, make it 0
        //if scoreDictionary[key] == nil {
        //
        //}
        
        
        return scoreDictionary
    }
    
    
    func save() {
        // Save userDictionary somewhere
        NSUserDefaults.standardUserDefaults().setObject(userDictionary, forKey: "UserDictionary")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    func load() {
        if let loadedDict = NSUserDefaults.standardUserDefaults().objectForKey("UserDictionary") as? [String: Int] {
            userDictionary = loadedDict
        }
    }
    

}