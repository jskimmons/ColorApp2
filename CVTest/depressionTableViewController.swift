//
//  depressionTableViewController.swift
//  CVTest
//
//  Created by Joseph Skimmons on 9/8/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

import UIKit

import UIKit

class depressionTableViewController: UITableViewController {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var moodPicker: UIPickerView!
    @IBOutlet weak var moodSlider: UISlider!
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        let step: Float = 1
        let currentValue = round((moodSlider.value - moodSlider.minimumValue) / step)
        print("\(currentValue)")
        
        switch currentValue {
        case 0:
            moodLbl.text = "Not at all"
        case 1:
            moodLbl.text = "Slight depression"
        case 2:
            moodLbl.text = "Some depression"
        case 3:
            moodLbl.text = "High depression"
        default:
            print("error")
        }
        
    }
    @IBOutlet weak var moodLbl: UILabel!
    
    var pickerData : [String] = []
    var pickedMood : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
