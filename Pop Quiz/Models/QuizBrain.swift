//
//  QuizBrain.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/15/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation

class QuizBrain {
    
    // Setting up singleton to handle data management from multiple view controllers
    static let shared = QuizBrain()
    let insults = InsultManager()
    var quiz = QuestionManager()
    var soundEffect = SoundManager()
    
    // QuizBrain has a delegate property so it can be set by it's delegate as self. Our ViewController's "newGame" set's itself as the delegate for QuizBrain
    var delegate: QuizBrainDelegate?
    
    //Setting up the arrays to hold the questions and answers. Incorrect Answers come as an array of arrays from API
    var questionArray = [String]()
    var correctAnswerArray = [String]()
    var incorrectAnswersArray = [[String]]()
    
    var categoryChosen: String? = nil
    var questionNumber = 0
    var score = 0
    var numberOfCorrectAnswers = 0
    var soundToPlay: String?
    
    
//MARK:- Game Flow Functions
    
    func loadNewQuiz(_ chosenCategory: String) {
        questionArray = []
        correctAnswerArray = []
        incorrectAnswersArray = []
        questionNumber = 0
        numberOfCorrectAnswers = 0
        score = 0
        
        //Set our quiz as the delegate of this instance of QuestionManager
        self.quiz.delegate = self
        
        //getting category ID from CategoryManager with the categoryChosen in Welcome VC
        var id: Int?
        if let category = categoryChosen {
        guard let categoryID = CategoryManager.categories[category] else {fatalError("Category chosen does not exist")}
            id = categoryID
        }
         // Get new set of questions as an instance of QuestionManager passing in the cattegory chosen id
        quiz.fetchQuestions(category: id)
    }
    
        func nextQuestion() {
        questionNumber += 1
    }
    
//TODO:- Set to 9 after testing is complete
    func isGameOver() -> Bool {
        if questionNumber == 3 {
            checkHighScore(score)
            checkCategoryHighScore(category: categoryChosen!, score: score)
            return true
        } else {
            return false
        }
    }
    
//MARK:- Getters
    
    func getQuestion() -> String {
        let quetstion = questionArray[questionNumber]
        return quetstion
    }
    
    func getCorrectAnswer() -> String {
        let correctAnswer = correctAnswerArray[questionNumber]
        return correctAnswer
    }
    
    func getRandomAnswers() -> [String] {
        //Combines correct and incorrect answers into single array and randomizes them
        incorrectAnswersArray[questionNumber].append(correctAnswerArray[questionNumber])
        let answersRandomized = incorrectAnswersArray[questionNumber].shuffled()
        return answersRandomized
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getHighScore() -> Int {
        //This is 0 by default since we call .integer
        return UserDefaults.standard.integer(forKey: "highScore")
    }
    
    func getCategoryHighScore(category: String) -> Int {
        return UserDefaults.standard.integer(forKey: "\(category)HighScore")
    }
    
    func getNumberOfCorrectAnswers() -> Int {
        return numberOfCorrectAnswers
    }
    
    func getInsult() -> String {
        
        var insult: String
        
        switch numberOfCorrectAnswers {
        case 0:
            insult = "\(insults.tier1Insults.randomElement() ?? "I have nothing to say...")"
        case 1:
            insult = "\(insults.tier2Insults.randomElement() ?? "I have nothing to say...")"
        case 2...7:
            insult = "\(insults.tier3Insults.randomElement() ?? "I have nothing to say...")"
        case 8...9:
            insult = "\(insults.tier4Insults.randomElement() ?? "I have nothing to say...")"
        case 10:
            insult = "\(insults.tier5Insults.randomElement() ?? "I have nothing to say...")"
        default:
            insult = "I have nothing to say"
        }
        
        return insult
    }
    
    func getSound(correctAnswer: Bool) -> String {
        
        if correctAnswer {
            soundToPlay = soundEffect.correctSounds.randomElement()
            return soundToPlay!
        } else {
            soundToPlay = soundEffect.incorrectSounds.randomElement()
            return soundToPlay!
        }
        
    }
    
//MARK:- Setters
    
    func checkAnswer(_ userAnswer: String, _ counter: Int) -> Bool {
        if userAnswer == correctAnswerArray[questionNumber] {
            score += counter
            numberOfCorrectAnswers += 1
            return true
        } else {
            return false
        }
    }
    
    func checkHighScore(_ score: Int) {
        if score > getHighScore() {
            UserDefaults.standard.set(score, forKey: "highScore")
        }
    }
    
    func checkCategoryHighScore(category: String, score: Int) {
        if score > getCategoryHighScore(category: category) {
            UserDefaults.standard.set(score, forKey: "\(category)HighScore")
        }
    }
}

//MARK: - Extension. Extending QuizBrain to include QuestionManagerDelegate to handle protocol requirements and pass data
extension QuizBrain: QuestionManagerDelegate {
    
    func didUpdateQuestions(questionManager: QuestionManager, questions: QuestionModel) {
        
        DispatchQueue.main.async {
            
            self.correctAnswerArray.append(contentsOf: questions.correct_answer)
            self.correctAnswerArray = self.correctAnswerArray.map { (answer) in
                String(htmlEncodedString: answer) ?? answer
            }
            
            self.questionArray.append(contentsOf: questions.question)
            self.questionArray = self.questionArray.map { (question) in
                String(htmlEncodedString: question) ?? question
                
            }
            
            self.incorrectAnswersArray.append(contentsOf: questions.incorrect_answers)
            for i in self.incorrectAnswersArray.indices {
                self.incorrectAnswersArray[i] = self.incorrectAnswersArray[i].map { answer in
                    String(htmlEncodedString: answer) ?? answer
                }
            }
            
            self.delegate?.finishedUpdatingQuestions()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error: \(error)")
    }
}

// MARK: - Protocol to allow UI to update after quiz is retrieved from API
protocol QuizBrainDelegate {
    func finishedUpdatingQuestions() 
}

// MARK: - Extending String to fix HTML strings passed back from API
extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
        
    }
    
}
