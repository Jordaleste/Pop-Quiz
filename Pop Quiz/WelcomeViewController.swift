//
//  WelcomeViewController.swift
//  Pop Quiz
//
//  Created by Turner Eison on 5/19/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation
import UIKit

// Next fill out UI, make segue to VC
// Test App

class WelcomeViewController: UIViewController {
    
    
    @IBAction func startButtonPressed(_ sender: Any) {
        
        //if picker.value == "Allquestions" {
        //QuizBrain.shared.categoryChosen = nil }
        //else { put quizbrain.shared below here }
        
        //pass value to quizbrain
        QuizBrain.shared.categoryChosen = "Science" //= picker.value or something
        //load segue to ViewController
    }
}
