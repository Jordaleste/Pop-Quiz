//
//  QuizBrain.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/15/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation

class QuizBrain {
    
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
    
    func loadNewQuiz() {
        questionNumber = 0
        
        //Set our quiz as the delegate of this instance of QuestionManager
        self.quiz.delegate = self
        
         // Get new set of questions as an instance of QuestionManager
        quiz.fetchQuestions()
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
        if questionNumber + 1 < questionArray.count {
            questionNumber += 1
        } else {
            questionNumber = 0
            print("New game started")
            score = 0
        }
    }
    
    func checkAnswer(_ userAnswer: String) -> Bool {
        if userAnswer == correctAnswerArray[questionNumber] {
            score += 1
            return true
        } else {
            return false
        }
    }
    
    func getScore() -> Int {
        return score
    }
    
    func isGameOver() -> Bool {
        if questionNumber == 9 {
            return true
        } else {
            return false
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
