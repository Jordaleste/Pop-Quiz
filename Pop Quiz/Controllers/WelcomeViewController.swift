//
//  WelcomeViewController.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/19/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    let categories = CategoryManager.categories.map( {$0.key}).sorted()
    lazy var chosenCategory = categories[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        QuizBrain.shared.categoryChosen = chosenCategory
        self.performSegue(withIdentifier: "gotoQuiz", sender: self)
    }

}
//MARK: - PickView Functions

extension WelcomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenCategory = categories[row]
        print(chosenCategory)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        
        pickerLabel.text = categories[row]
        pickerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        pickerLabel.layer.borderColor = UIColor.red.cgColor
        pickerLabel.layer.borderWidth = 2
        pickerLabel.backgroundColor = .yellow
        
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
}
