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
    var currentQuestionKey: String?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func getNextQuestion(sender: AnyObject) {
        
        // Save
        if let currentKey = currentQuestionKey {
            UserProfile.sharedProfile.updateScoreForKey(currentKey, deltaValue: currentValue)
        }
        
        // Get a new key/question
        currentQuestionKey = QuestionStore.sharedStore.returnRandomKey()
        
        if let currentKey = currentQuestionKey {
            // We have a valid key
            if let nextQuestionString = QuestionStore.sharedStore.randomQuestionForKey(currentKey) {
                // We have a valid question
                self.questionLabel.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.questionLabel.text = nextQuestionString
                    self.questionLabel.fadeIn()
                })
            } else {
                // We do not have a valid question
                self.questionLabel.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.questionLabel.text = "Question not found"
                    self.questionLabel.fadeIn()
                })
            }
        }
    }
    
    @IBAction func sliderChange(sender: UISlider) {
    
        //pass value to questionvalue
        currentValue = Int(roundf(sender.value))
        
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
        
        if let theSlider = slider {
            theSlider.value = Float(currentValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentQuestionKey = QuestionStore.sharedStore.returnRandomKey()
        
        questionLabel.alpha = 0
        
        //return random question
        if let currentKey = currentQuestionKey {
            questionLabel.text = QuestionStore.sharedStore.randomQuestionForKey(currentKey)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        questionLabel.fadeIn()
    }
}

