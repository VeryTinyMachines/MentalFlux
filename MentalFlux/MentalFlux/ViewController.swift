//
//  ViewController.swift
//  MentalFlux
//
//  Created by Andrew J Clark on 14/09/2015.
//  Copyright © 2015 Very Tiny Machines. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //import class
    let questionStore = questionRandomizer()
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func questionButton(sender: AnyObject) {
        label.text = questionStore.randomize() as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = questionStore.randomize() as! String

        
        //questionStore = dict!.objectForKey("(B) Body-Kinesthetic") as! [String]
        
    }
    




}

