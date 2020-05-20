//
//  QuestionManager.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/15/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation



struct QuestionManager {
    
    //Set here to allow to adjust in future updates user choice of quiz type, etc...
    
    
    // QuestionManager has a delegate property so it can be set by it's delegate as self. Our QuizBrain's "quiz" set's itself as the delegate for QuestionManager
    var delegate: QuestionManagerDelegate?
    
    //QuizBrain will pass in the category id, nil is default
    func fetchQuestions(category: Int? = nil) {
        //Base URL for API
        var urlString = "https://opentdb.com/api.php?amount=10"
        
        //Add category chosen for API
        if let category = category {
            urlString += "&category=\(category)"
            print("Chosen Category: \(urlString)")
        }
        if let url = URL(string: urlString) {
            print("All Questions \(urlString)")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //Tells our delegate to run it's didFailWithError method
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    // Parse the returned JSON file
                    if let questions = self.parseJSON(safeData) {
                        //Tells our delegate to run it's didUpdateQuestions method
                        self.delegate?.didUpdateQuestions(questionManager: self, questions: questions)
                    }
                }
            }
            
            
            //This runs the API call
            task.resume()
        }
    }
    
    func parseJSON(_ questionData: Data) -> QuestionModel? {
        let decoder = JSONDecoder()
        
        //getting an instance of our QuestionModel
        var questionModel = QuestionModel(question: [], correct_answer: [], incorrect_answers: [])
        
        do {
            let decodedData = try decoder.decode(QuestionData.self, from: questionData)
            
            //passing in API info which is 10 "entries" into arrays from QuestionData into the QuestionModel, which is what we want to work with throughout. Used QData and QModel because we get back 10 "question/answers", needed grouped up, done in QData, then split out by QModel. If we like the way the info comes back from the API, we could use the QData alone and not need the QModel.
            for i in 0...9 {
                let question = decodedData.results[i].question
                let correct_answer = decodedData.results[i].correct_answer
                let incorrect_answers = decodedData.results[i].incorrect_answers
                
                //add the items into our arrays
                questionModel.question.append(question)
                questionModel.correct_answer.append(correct_answer)
                questionModel.incorrect_answers.append(incorrect_answers)
            }
            
            return questionModel
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


// MARK: - Protocol to allow QuizBrain to update questions. This is called during our fetchQuestion method below.
protocol QuestionManagerDelegate {
    func didUpdateQuestions(questionManager: QuestionManager, questions: QuestionModel)
    func didFailWithError(error: Error)
    
}

