//
//  ViewController.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/13/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, QuizBrainDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var cButtonLabel: UIButton!
    @IBOutlet weak var dButtonLabel: UIButton!
    @IBOutlet weak var insultButtonLabel: UILabel!
    @IBOutlet weak var scoreButtonLabel: UIButton!
    
    var player: AVAudioPlayer!
    var feedBackGenerator : UINotificationFeedbackGenerator? = nil
    lazy var buttonArray = [aButton, bButton, cButton, dButton]
    
    // Get new game, instance of QuizBrain
    // Using a singleton shared instance to allow passing of values from multiple view controllers
    var newGame = QuizBrain.shared
    
    var timer = Timer()
    var counter = 100
    var soundToPlay: String?
    var doPlaySound = false
    let playSoundFileProbability = 4
    let timeAfterAnswerInSeconds = 2.5
    let scoreCountDownIntervalInSeconds = 0.1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set our newGame as the delegate of this instance of QuizBrain
        newGame.delegate = self
        newGame.loadNewQuiz(newGame.categoryChosen!)
        
        highScoreLabel.layer.cornerRadius = 5
        highScoreLabel.clipsToBounds = true
        highScoreLabel.text = "All Time Luckiest Score: \(newGame.getHighScore())\n\(newGame.categoryChosen ?? "Chosen Category")\nLuckiest Score: \(newGame.getCategoryHighScore(category: newGame.categoryChosen!))"
        
        questionLabel.layer.cornerRadius = 5
        questionLabel.clipsToBounds = true
        
        insultButtonLabel.isHidden = true
        insultButtonLabel.backgroundColor = .green
        insultButtonLabel.layer.cornerRadius = 5
        insultButtonLabel.clipsToBounds = true
        
        scoreButtonLabel.layer.cornerRadius = 5
        scoreButtonLabel.clipsToBounds = true
        
        for button in buttonArray {
            button?.titleLabel?.minimumScaleFactor = 0.5
            button?.titleLabel?.numberOfLines = 1
            button?.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    //MARK:- Game Play UI Functions
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        //Stop the score keeping timer
        timer.invalidate()
      
        guard let answerChosen = sender.currentTitle else {
            print("No text in sender.currentTitle")
            return
        }
        //Disable buttons so only 1 answer can be chosen
        for i in buttonArray {
            i?.isUserInteractionEnabled = false
        }
        
        let userIsCorrect = newGame.checkAnswer(answerChosen, counter)
        
        if userIsCorrect {
            feedBackGenerator?.notificationOccurred(.success)
            sender.backgroundColor = .green
            scoreButtonLabel.setTitle("Number of Correct Answers: \(newGame.getNumberOfCorrectAnswers()):  Score: \(newGame.getScore())", for: .normal)
            
            
            playRandomSound(isCorrect: true)
            
        } else {
            feedBackGenerator?.notificationOccurred(.error)
            sender.backgroundColor? = .red
            sender.setTitleColor(.white, for: .normal)
            let correctAnswer = newGame.getCorrectAnswer()
            for i in buttonArray {
                if i?.currentTitle == correctAnswer {
                    i?.backgroundColor = .green
                }
                
                playRandomSound(isCorrect: false)
            }
        }
        
        if self.newGame.isGameOver() {
            self.gameOver()
        } else {
            //Reset the score keeping counter for next question
            counter = 100
            //Leave correct answer shown for set time, then move on to next question
            Timer.scheduledTimer(withTimeInterval: timeAfterAnswerInSeconds, repeats: false) { _ in
                for i in self.buttonArray {
                    i?.backgroundColor = .white
                    i?.setTitleColor(.red, for: .normal)
                    i?.isHidden = false
                    i?.isUserInteractionEnabled = true
                }
                
                for i in [self.cButtonLabel, self.dButtonLabel] {
                    i?.isHidden = false
                }
                if self.doPlaySound {
                    self.player.stop()
                    self.doPlaySound = false
                    
                }
                self.newGame.nextQuestion()
                self.updateUI()
            }
        }
    }
    
    @IBAction func startOverButtonPressed(_ sender: UIButton) {
        //Dismiss VC and return to Welcome VC for new game
        dismiss(animated: true) {
        }
    }
    
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player.play()
        } catch {
            print("Error retrieving souond effect \(error)")
        }
    }
    //Play random sound 1/playSoundFileProbability times
    func playRandomSound(isCorrect: Bool) {
        let randomNumberGenerator = Int.random(in: 1...playSoundFileProbability)
        if randomNumberGenerator == 1 {
            doPlaySound = true
        }
        
        if doPlaySound {
            soundToPlay = newGame.getSound(correctAnswer: isCorrect)
            if soundToPlay != nil {
                playSound(soundName: soundToPlay!)
            }
        }
    }
    
//MARK:- Game Over / Update UI Functions
    
    func gameOver() {
        feedBackGenerator = nil
        //Set final screen UI, enable start over button
        insultButtonLabel.isHidden = false
        insultButtonLabel.text = "\(newGame.getInsult())"
        scoreButtonLabel.isUserInteractionEnabled = true
        scoreButtonLabel.backgroundColor = .green
        scoreButtonLabel.setTitleColor(.red, for: .normal)
        scoreButtonLabel.setTitle("Number of Correct Answers: \(newGame.getNumberOfCorrectAnswers())\nFinal Score: \(newGame.getScore()).      Play Again?", for: .normal)
    }
    
    func updateUI() {
        //Randomize answers from API so correct answer is not in same location every time
        let randomAnswers = newGame.getRandomAnswers()
        feedBackGenerator = UINotificationFeedbackGenerator()
        feedBackGenerator?.prepare()
        //Show question
        questionLabel.text = newGame.getQuestion()
        aButton.setTitle(randomAnswers[0], for: .normal)
        bButton.setTitle(randomAnswers[1], for: .normal)
        
        //Show answers based on # of available choices from API, which range from 2-4
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
        
        //Score keeping system. Max 100, -1 point every 1/10 second, cap at 50 min. for correct answer
        timer = Timer.scheduledTimer(withTimeInterval: scoreCountDownIntervalInSeconds, repeats: true) { _ in
            self.counter -= 1
            
            if self.counter <= 50 {
                self.timer.invalidate()
            }
        }
    }

    //MARK:- Protocol Functions
    //Handles protocol requirement from QuizBrainDelegate. This (VERY IMPORTANT) delays the refreshing of the UI until the API call is complete. Otherwise, APP can crash if API call takes too long, which is does, every time lol.
    func finishedUpdatingQuestions() {
        updateUI( )
    }
}
