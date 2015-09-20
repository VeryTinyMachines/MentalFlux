//
//  ViewController.swift
//  MentalFlux
//
//  Created by Andrew J Clark on 14/09/2015.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Variables
    var currentValue = 0
    var questionValue = 0
    var questionID = ""
    
    //import classes
    let questionStore = questionRandomizer()
    let profile = UserProfile()

    //Storyboard Elements
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
    
    //Send data to plist: UserProfile
    @IBAction func questionButton(sender: AnyObject) {
        
        //set questionValue to the value of the slider
        questionValue = currentValue
        
        //test to see if questionvalue holds the correct data (it does)
        outputLabel.text = String(questionValue)
        //
        profile.calculateResults(questionValue, question: questionID)
        
        //store data
        profile.storeData(questionID, value: questionValue)
        
    }
    
    @IBAction func sliderChange(sender: UISlider) {

        label.text = "\(currentValue)"
        //pass value to questionvalue
        currentValue = Int(sender.value)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //questionStore = dict!.objectForKey("(B) Body-Kinesthetic") as! [String]
        //questionStore.loadPlist()
        
    }
    




}

