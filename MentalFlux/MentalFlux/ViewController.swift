//
//  ViewController.swift
//  MentalFlux
//
//  Created by Andrew J Clark on 14/09/2015.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentValue = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var agreementLabel: UILabel!
    

    
    @IBAction func getNextQuestion(sender: AnyObject) {
        
        let key = QuestionStore.sharedStore.returnRandomKey()
        
        self.questionLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.questionLabel.text = QuestionStore.sharedStore.randomQuestionForKey(key!)
            self.questionLabel.fadeIn()
        })
        //store the value
        UserProfile.sharedProfile.updateScoreForKey(key!, deltaValue: currentValue)
        
        /*
        //return random question
        questionLabel.text = QuestionStore.sharedStore.randomQuestionForKey(key)
        
        //store the value
        UserProfile.sharedProfile.updateScoreForKey(key, deltaValue: currentValue)
        */
    }
    
    @IBAction func sliderChange(sender: UISlider) {
    
        //Switch Statement
            //case0 sliderLabel.text = "Strongly Disagree"
            //case1 sliderLabel.text = "Disagree"
            //case2 sliderLabel.text = "Neither"
            //case3 sliderLabel.text = "Agree"
            //case4 sliderLabel.text = "Strongly Agree"
        

        switch currentValue
        {
        case 0:
            sliderLabel.text = "Strongly Disagree"
        case 1:
            sliderLabel.text = "Disagree"
        case 2:
            sliderLabel.text = "Neither"
        case 3:
            sliderLabel.text = "Agree"
        case 4:
            sliderLabel.text = "Strongly Agree"
        default:
            sliderLabel.text = "Neither"
        }
        //sliderLabel.text = "\(currentValue)"
        //pass value to questionvalue
        currentValue = Int(sender.value)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        UserProfile.sharedProfile.updateScoreForKey("B", deltaValue: 4)
        
        let score = UserProfile.sharedProfile.currentScoreForKey("B")
        
        print(score, appendNewline: true)
        */
        let key = QuestionStore.sharedStore.returnRandomKey()
        
        self.questionLabel.alpha = 0
        
        //return random question
        questionLabel.text = QuestionStore.sharedStore.randomQuestionForKey(key!)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(1.2, animations: { () -> Void in
        self.questionLabel.alpha = 2
        })
    }
    




}

