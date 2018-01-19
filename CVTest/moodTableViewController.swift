//
//  MoodTableViewController.swift
//  CVTest
//
//  Created by Joseph Skimmons on 9/7/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

import UIKit

class moodTableViewController: UITableViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var moodPicker: UIPickerView!
    @IBOutlet weak var moodSlider: UISlider!
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        let step: Float = 1
        let currentValue = round((moodSlider.value - moodSlider.minimumValue) / step)
        print("\(currentValue)")
        
        switch currentValue {
        case 0:
            moodLbl.text = "You felt awful today"
        case 1:
            moodLbl.text = "You felt poorly today"
        case 2:
            moodLbl.text = "You felt alright today"
        case 3:
            moodLbl.text = "You felt well today"
        case 4:
            moodLbl.text = "You felt great today"
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
        
        // Connect data:
        self.moodPicker.delegate = self
        self.moodPicker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Much better than yesterday", "Slightly better than yesterday", "About the same as yesterday", "Slightly worse than yesterday", "Much worse than yesterday"]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
        pickedMood = pickerData[row]
        
    }

    
}
