//
//  ViewController.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/13/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizBrainDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var cButtonLabel: UIButton!
    @IBOutlet weak var dButtonLabel: UIButton!
    @IBOutlet weak var scoreButtonLabel: UIButton!
    
    
    lazy var buttonArray = [aButton, bButton, cButton, dButton]
    
    // Get new game, instance of QuizBrain
    // Using a singleton shared instance to allow passing of values from multiple view controllers
    var newGame = QuizBrain.shared
    
    var timer = Timer()
    var counter = 100
    var numberOfCorrectAnswers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set our newGame as the delegate of this instance of QuizBrain
        newGame.delegate = self
        newGame.loadNewQuiz(newGame.categoryChosen!) 
        questionLabel.layer.cornerRadius = 5
        questionLabel.clipsToBounds = true
        scoreButtonLabel.layer.cornerRadius = 5
        scoreButtonLabel.clipsToBounds = true
        
        
        for button in buttonArray {
            button?.titleLabel?.minimumScaleFactor = 0.5
            button?.titleLabel?.numberOfLines = 1
            button?.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        //Stop the score keeping timer
        timer.invalidate()
        
        guard let answerChosen = sender.currentTitle else {
            print("No text in sender.currentTitle")
            return
        }
        
        for i in buttonArray {
            i?.isUserInteractionEnabled = false
        }
        
        let userIsCorrect = newGame.checkAnswer(answerChosen, counter)
        
        if userIsCorrect {
            print("Correct, points: \(counter)")
            numberOfCorrectAnswers += 1
            sender.backgroundColor = .green
            scoreButtonLabel.setTitle("Number of Correct Answers: \(newGame.getNumberOfCorrectAnswers()):  Score: \(newGame.getScore())", for: .normal)
            //score should be based on time taken to answer

        } else {
            sender.backgroundColor? = .red
            sender.setTitleColor(.white, for: .normal)
            let correctAnswer = newGame.getCorrectAnswer()
            for i in buttonArray {
                if i?.currentTitle == correctAnswer {
                    i?.backgroundColor = .green
                }
            }
        }
        
        if self.newGame.isGameOver() {
            self.gameOver()
        } else {
            //Reset the score keeping counter for next question
            counter = 100
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                for i in self.buttonArray {
                    i?.backgroundColor = .white
                    i?.setTitleColor(.red, for: .normal)
                    i?.isHidden = false
                    i?.isUserInteractionEnabled = true
                }
                
                for i in [self.cButtonLabel, self.dButtonLabel] {
                    i?.isHidden = false
                }
                self.newGame.nextQuestion()
                self.updateUI()
            }
        }
    }
    
    @IBAction func startOverButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true) {
            
        }
//        Code to reset the game if same category is selected provided we program an additional option later
//        for i in self.buttonArray {
//            i?.backgroundColor = .white
//            i?.setTitleColor(.red, for: .normal)
//            i?.isHidden = false
//            i?.isUserInteractionEnabled = true
//        }
//        
//        scoreButtonLabel.backgroundColor = .red
//        scoreButtonLabel.setTitleColor(.white, for: .normal)
//        scoreButtonLabel.setTitle("Score: \(newGame.getScore())", for: .normal)
//
//        newGame.loadNewQuiz(newGame.categoryChosen!)
    }
    
    func gameOver() {
        scoreButtonLabel.isUserInteractionEnabled = true
        scoreButtonLabel.backgroundColor = .green
        scoreButtonLabel.setTitleColor(.red, for: .normal)
        scoreButtonLabel.setTitle("Number of Correct Answers: \(newGame.getNumberOfCorrectAnswers()): Final Score: \(newGame.getScore()). Play Again?", for: .normal)
    }
    
    func updateUI() {
        
        let randomAnswers = newGame.getRandomAnswers()
        
        questionLabel.text = newGame.getQuestion()
        aButton.setTitle(randomAnswers[0], for: .normal)
        bButton.setTitle(randomAnswers[1], for: .normal)
        
        if randomAnswers.count > 2 {
            cButton.setTitle(randomAnswers[2], for: .normal)
            
            if randomAnswers.count > 3 {
                dButton.setTitle(randomAnswers[3], for: .normal)
            } else {
                self.dButton.isHidden = true
                self.dButtonLabel.isHidden = true
            }
        } else {
            self.cButton.isHidden = true
            self.cButtonLabel.isHidden = true
            self.dButton.isHidden = true
            self.dButtonLabel.isHidden = true
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter -= 1
            
            if self.counter > 50 {
                print("\(self.counter)")
            } else {
                self.timer.invalidate()
                print("Final Score: \(self.counter)")
            }
            
            //if answer is correct, add to score based on time. If incorrect, do not add to score
        }
    }
    
    //Handles protocol requirement from QuizBrainDelegate. This (VERY IMPORTANT) delays the refreshing of the UI until the API call is complete. Otherwise, APP can crash if API call takes too long, which is does, every time lol.
    func finishedUpdatingQuestions() {
        updateUI( )
    }
    
}
