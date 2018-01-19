//
//  ReadoutViewController.swift
//  CVTest
//
//  Created by Joseph Skimmons on 7/26/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

import UIKit
import AVFoundation


class ReadoutViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var readoutLabel: UILabel!
    
    @IBOutlet weak var animatedView: UIView!
    
    @IBOutlet weak var modeSwitch: UISegmentedControl!
    
    @IBOutlet weak var safeLabel: UILabel!
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        animatedView.isHidden = true
        safeLabel.isHidden = true
        animatedView.layer.cornerRadius = 100.0
        animatedView.clipsToBounds = true
        animatedView.backgroundColor = UIColor.red
/*
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
*/        
       
        let defaults = UserDefaults.standard
        
        let day = String(describing: self.getDay()!)
        let year = String(describing: self.getYear())
        let month = self.getMonth()
        
        var first = ""
        
        if let firstName = defaults.string(forKey: "firstName"){
            first = firstName
        }
        
        var age = ""
        
        if let date = defaults.object(forKey: "bdayDate"){
            age = String(calculateAge(birthday: date as! NSDate))
        }
        
        //print(calculateAge(birthday: defaults.object(forKey: "bdayDate") as! NSDate))
        
        let line1 = "Hello " + first + "," + " please try to stay relaxed "
        let line2 = "This is just a memory."
        let line3 = "You are safe"
        let line4 = "Today's date is " + month + " " + day + " " + year
        let line5 = "And the time is " + getTime()
        let line6 = "Right now, you are at [location]"
        let line7 = "Try to keep your eyes open and breathe"
        let line8 = "What you're feeling is a memory"
        let line9 = "You're " + "[age]" + " years old"
        let line10 = "The events you're remembering are in the past"
        let line11 = "Try to remember yesterday, when you were [memory from journal]" // TODO
        let line12 = "You felt safe there"
        let line13 = "Try to remember this morning, when you were [memory from journal]"//TODO
        let line14 = "That made you smile"
        let line15 = "You're " + "[age]" + " years old"
        let line16 = "The events you're remembering are in the past"
        let line17 = first + " you are safe."
        
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        
        activateSpeech(input: line1, synth: synthesizer)
        activateSpeech(input: line2, synth: synthesizer)
        activateSpeech(input: line3, synth: synthesizer)
        
        if (defaults.bool(forKey: "dissociation")){
            activateSpeech(input: line4, synth: synthesizer)
            activateSpeech(input: line5, synth: synthesizer)
            activateSpeech(input: line6, synth: synthesizer)
        }
        if (defaults.bool(forKey: "anxiety")){
            activateSpeech(input: line7, synth: synthesizer)
            activateSpeech(input: line8, synth: synthesizer)
            activateSpeech(input: line9, synth: synthesizer)
        }
        if (defaults.bool(forKey: "dissociation")){
            activateSpeech(input: line8, synth: synthesizer)
            activateSpeech(input: line9, synth: synthesizer)
        }
        
        activateSpeech(input: line10, synth: synthesizer)
        
        if (defaults.bool(forKey: "dissociation")){
            activateSpeech(input: line11, synth: synthesizer)
            activateSpeech(input: line12, synth: synthesizer)
        }
        if (defaults.bool(forKey: "depression")){
            activateSpeech(input: line13, synth: synthesizer)
            activateSpeech(input: line14, synth: synthesizer)
        }
        if (defaults.bool(forKey: "dissociation")){
            activateSpeech(input: line15, synth: synthesizer)
            
        }
        activateSpeech(input: line16, synth: synthesizer)
        activateSpeech(input: line17, synth: synthesizer)
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTime() -> String {
        // returns string of date and time for journal
        
        var AMPMString = " AM"
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year = components.year!
        let month = components.day!
        let day = components.month!
        
        var hour = calendar.component(.hour, from: date)
        var minutes = calendar.component(.minute, from: date)
        var minString = ""
        
        if minutes < 10 {
            minString = "0" + String(describing: minutes)
        }
        else{
            minString = String(describing: minutes)
        }
        
        if (hour > 12){
            hour %= 12
            AMPMString = " PM"
        }
        
        var timeString = String(describing: hour) + ":" + minString + AMPMString

        
        return timeString
    }

    

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: characterRange)
        readoutLabel.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        readoutLabel.attributedText = NSAttributedString(string: utterance.speechString)
    }
    
    func activateSpeech(input: String, synth : AVSpeechSynthesizer) {
        
        self.readoutLabel.text = input
        
        let utterance = AVSpeechUtterance(string: input)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synth.speak(utterance)
        
    }
    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        switch modeSwitch.selectedSegmentIndex
        {
        case 0:
            readoutLabel.isHidden = false
            animatedView.isHidden = true
            safeLabel.isHidden = true
        case 1:
            self.animatedView.center.x = 50
            self.readoutLabel.isHidden = true
            self.animatedView.isHidden = false
            self.safeLabel.isHidden = true
            self.readoutLabel.isHidden = true
            self.animatedView.isHidden = false
            UIView.animate(withDuration: 2.0, delay: 0.4,
                           options: [.repeat, .autoreverse, .curveEaseInOut],
                           animations: {
                            self.animatedView.center.x += self.view.bounds.width - 100
            },
                           completion: nil
            )
        case 2:
            safeLabel.isHidden = false
            readoutLabel.isHidden = true
            animatedView.isHidden = true
            
        case 3:
            let VC5 = self.storyboard?.instantiateViewController(withIdentifier: "colorNav") //as! safePlaceViewController
            present(VC5!, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func getMonth() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        let month = components.month

        
        var yearString = ""
        
        switch (month!) {
        case 1:
            yearString = "January"
        case 2:
            yearString = "February"
        case 3:
            yearString = "March"
        case 4:
            yearString = "April"
        case 5:
            yearString = "May"
        case 6:
            yearString = "June"
        case 7:
            yearString = "July"
        case 8:
            yearString = "August"
        case 9:
            yearString = "September"
        case 10:
            yearString = "October"
        case 11:
            yearString = "November"
        case 12:
            yearString = "December"
        default:
            yearString = "error"
        }
        
        return yearString
        
    }
    
    func getYear() -> Int {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year = components.year!
        
        return year
        
    }
    
    func getDay() -> Int? {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let day = components.day
        
        return day
    }
    
    @IBAction func saveColorViewController(segue:UIStoryboardSegue) {
        
    }
    
    func calculateAge (birthday: NSDate) -> Int {
        let gregorian = Calendar(identifier: .gregorian)
        let ageComponents = gregorian.dateComponents([.year], from: birthday as Date, to: Date())
        let age = ageComponents.year!
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let strDate = dateFormatter.string(from: bdayPick.date)
        self.bdayDisplay.text = strDate
        */
        return age
    }
    
    
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    
    
    // MARK: - UICollectionViewDelegate protocol
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if (self.items[indexPath.item] == "Default"){
            // default readout
            readoutLabel.isHidden = false
            animatedView.isHidden = true
        }
        else if (self.items[indexPath.item] == "EDMA"){
            // animation code
            animatedView.center.x = 50
            readoutLabel.isHidden = true
            animatedView.isHidden = false
            UIView.animate(withDuration: 2.0, delay: 0.4,
                           options: [.repeat, .autoreverse, .curveEaseInOut],
                           animations: {
                            self.animatedView.center.x += self.view.bounds.width - 100
            },
                           completion: nil
            )
        }
        
    }
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // WHAT. THE. FUCK. IS. GOING. ON
        //var size = self.myCollectionView.collectionViewLayout.collectionViewContentSize
        //print(size)
        var size = CGSize(width: self.view.frame.width, height: 100.0)
        
        return size
 
    }
 
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    */
  /*
    func snapToNearestCell(_ collectionView: UICollectionView) {
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let itemWithSpaceWidth = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
            let itemWidth = collectionViewFlowLayout.itemSize.width
            
            if collectionView.contentOffset.x <= CGFloat(i) * itemWithSpaceWidth + itemWidth / 2 {
                let indexPath = IndexPath(item: i, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                break
            }
        }
    }
 
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapToNearestCell(myCollectionView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        snapToNearestCell(myCollectionView)
    }
 */
    
/*
    func numberOfScrollViewElements() -> Int {
        return 3
    }
    
    func elementAtScrollViewIndex(index: Int) -> UIView {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        var button = UIButton()
        button.frame = view.frame
        button.setTitle("Hello \(index)", for: UIControlState.normal)
        button.backgroundColor = UIColor.red
        view.addSubview(button)
        return view
    }
*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
