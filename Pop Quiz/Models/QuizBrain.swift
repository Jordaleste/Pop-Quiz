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
    var categoryChosen: String? = nil
    
    // QuizBrain has a delegate property so it can be set by it's delegate as self. Our ViewController's "newGame" set's itself as the delegate for QuizBrain
    var delegate: QuizBrainDelegate?
    
   
    var quiz = QuestionManager()
    var questionNumber = 0
    
    //Setting up the arrays to hold the questions and answers
    var questionArray = [String]()
    var correctAnswerArray = [String]()
    //Incorrect Answers come in an array of arrays of Strings from API
    var incorrectAnswersArray = [[String]]()
    
    var score = 0
    var numberOfCorrectAnswers = 0
    
    func loadNewQuiz(_ chosenCategory: String) {
        questionArray = []
        correctAnswerArray = []
        incorrectAnswersArray = []
        questionNumber = 0
        numberOfCorrectAnswers = 0
        score = 0
        
        //Set our quiz as the delegate of this instance of QuestionManager
        self.quiz.delegate = self
        
        //getting category ID from CategoryManager
        var id: Int?
        if let category = categoryChosen {
        guard let categoryID = CategoryManager.categories[category] else {fatalError("Category chosen does not exist")}
            id = categoryID
        }
         // Get new set of questions as an instance of QuestionManager passing in the cattegory chosen id
        quiz.fetchQuestions(category: id) //need to pass in category ID here
    }
    
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
    
    func nextQuestion() { 
        questionNumber += 1
    }
    
    func checkAnswer(_ userAnswer: String, _ counter: Int) -> Bool {
        if userAnswer == correctAnswerArray[questionNumber] {
            score += counter
            numberOfCorrectAnswers += 1
            return true
        } else {
            return false
        }
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
    
    func getNumberOfCorrectAnswers() -> Int {
        return numberOfCorrectAnswers
    }
    
    func isGameOver() -> Bool { // set to 9 after testing is complete
        if questionNumber == 3 {
            checkHighScore(score)
            checkCategoryHighScore(category: categoryChosen!, score: score)
            return true
        } else {
            return false
        }
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
        
//        if score == 0 {
//            saying = "Horrible"
//        } else if score > 0 && score < 100 {
//            saying = "From 1 - 99"
//        } else if score >= 100 && score < 250 {
//            saying = "From 100 - 249"
//        } else {
//            saying = "0"
//        }
        
        
        return insult
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
