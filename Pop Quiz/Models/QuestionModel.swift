//
//  QuestionModel.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/15/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation

struct QuestionModel {
    
    //These line up with API info we want. Can be named anything. 
    var question: [String]
    var correct_answer: [String]
    var incorrect_answers: [[String]]
    
}
