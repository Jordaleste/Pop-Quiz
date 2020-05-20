//
//  QuestionData.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/15/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation

struct QuestionData: Codable {
    
    //This is what we get back from our API
    let results: [Results] 
    
}
    //These must be named exact way API is named, name and type
struct Results: Codable {
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
}
