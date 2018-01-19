//
//  MainMenuViewController.swift
//  CVTest
//
//  Created by Joseph Skimmons on 6/19/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

//import Google

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var journalTable: UITableView!
    
    let reuseIdentifier = "journalCell" // also enter this string as the cell identifier in the storyboard
    var entries = [String]()
    var dates = [String]()
    var questions = [String]()
    var questProgression = ["Describe a place that makes you feel safe", "What's one thing that made you smile today?", "How is your overall mood today?", "Have you felt dissociated today?", "Have you felt anxious today?", "Have you felt depressed today?", "Thanks for answering!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
       
        if launchedBefore  {
            print("Not first launch.")
        } else {
            
            let VC6 = self.storyboard?.instantiateViewController(withIdentifier: "settingsNav") //as! safePlaceViewController
            present(VC6!, animated: true, completion: nil)
            
            //UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        let defaults = UserDefaults.standard
 
        if let entries = defaults.array(forKey: "entriesArr") {
            self.entries = entries as! [String]
        }
        if let dates = defaults.array(forKey: "datesArr") {
            self.dates = dates as! [String]
        }
        if let questions = defaults.array(forKey: "questionsArr") {
            self.questions = questions as! [String]
        }
        
        journalTable.reloadData()
 
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
         */
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(entries, forKey: "entriesArr")
        defaults.set(dates, forKey: "datesArr")
        defaults.set(questions, forKey: "questionsArr")
    }
    
    @IBAction func doneFlashback(segue:UIStoryboardSegue) {
        entries.append("Used flashback assistant")
        dates.append(self.getDate())
        questions.append(self.getTime())
        journalTable.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MActionBtn(_ sender: Any) {
    }
 
    @IBAction func cancelToViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelSettingsToViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func savesSettingsDetail(segue:UIStoryboardSegue) {
        
        let VC = segue.source as! SettingsTableViewController
        

        let defaults = UserDefaults.standard

        defaults.set(VC.phraseTF.text, forKey: "phrase")
        defaults.set(VC.lastNameTF.text, forKey: "lastName")
        defaults.set(VC.firstNameTF.text, forKey: "firstName")
        defaults.set(VC.bdayDisplay.text, forKey: "bday")
        defaults.set(VC.anxietyS.isOn, forKey: "anxiety")
        defaults.set(VC.dissociationS.isOn, forKey: "dissociation")
        defaults.set(VC.depressionS.isOn, forKey: "depression")
        defaults.set(VC.bdayPick.date, forKey: "bDayDate") as? NSDate ?? NSDate.distantFuture as NSDate
        
        print(defaults.object(forKey: "bdayDate"))
    
    }
    
    @IBAction func cancelNewEntryToViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveAnxietyToViewController(segue:UIStoryboardSegue) {
        let VC = segue.source as! anxietyTableViewController
        
        dates.append(self.getDate())
        questions.append(VC.questionLbl.text!)
        entries.append(VC.moodLbl.text!)
        
        
        UserDefaults.standard.set(getQIndex() + 1, forKey: "qindex")
        
        journalTable.reloadData()
        
    }
    
    @IBAction func saveDepressionToViewController(segue:UIStoryboardSegue) {
        let VC = segue.source as! depressionTableViewController
        
        dates.append(self.getDate())
        questions.append(VC.questionLbl.text!)
        entries.append(VC.moodLbl.text!)
        
        
        UserDefaults.standard.set(getQIndex() + 1, forKey: "qindex")
        
        journalTable.reloadData()
        
    }
    
    @IBAction func saveDissociationToViewController(segue:UIStoryboardSegue) {
        let VC = segue.source as! dissociationTableViewController
        
        dates.append(self.getDate())
        questions.append(VC.questionLbl.text!)
        entries.append(VC.moodLbl.text!)
        
        
        UserDefaults.standard.set(getQIndex() + 1, forKey: "qindex")
        
        journalTable.reloadData()
        
    }
    
    @IBAction func saveMoodToViewController(segue:UIStoryboardSegue) {
        let VC = segue.source as! moodTableViewController
        //entries.append(VC.responseView.text!)
        dates.append(self.getDate())
        questions.append(VC.questionLbl.text!)
        entries.append(VC.moodLbl.text! + ". " + VC.pickerData[VC.moodPicker.selectedRow(inComponent: 0)])
        
        
        UserDefaults.standard.set(getQIndex() + 1, forKey: "qindex")
        
        journalTable.reloadData()
        
    }
    
    @IBAction func saveSafePlaceToViewController(segue:UIStoryboardSegue) {
        let VC = segue.source as! safePlaceViewController
        entries.append(VC.responseView.text!)
        dates.append(self.getDate())
        questions.append(VC.questionLbl.text!)
        
        UserDefaults.standard.set(getQIndex() + 1, forKey: "qindex")
        
        journalTable.reloadData()

    }
    
    @IBAction func saveSmileToViewController(segue:UIStoryboardSegue) {
        let VC = segue.source as! smileTableViewController
        entries.append(VC.responseView.text!)
        dates.append(self.getDate())
        questions.append(VC.questionLbl.text!)
        
        UserDefaults.standard.set(getQIndex() + 1, forKey: "qindex")
        
        journalTable.reloadData()
        
    }
    
    @IBAction func saveNewEntryDetail(segue:UIStoryboardSegue) {
        
        let VC = segue.source as! NewEntryTableViewController
        entries.append(VC.responseView.text!)
        dates.append(self.getDate())
        questions.append("Custom Entry")
        
        journalTable.reloadData()
        print(entries)
        print(dates)
    }
    
    func getDate() -> String{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year = components.year!
        let month = components.day!
        let day = components.month!
        
        var dateString = String(describing: month) + " " + String(describing: day)
        
        return dateString
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
    
    func randomQuestion() {
        // randomizes question in questionLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count + 1
    }
    
    // qindex has to go in a place that is created when the app is created, and resets to 0 each day
    // app created, qindex: 0
    // cell about to be returned, qindex: ++
    // new day, qindex: 0
    
    
    // GOTTA DEBUG TODO
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row != entries.count){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell") as! JournalTableViewCell
            cell.position = indexPath.row
            
            cell.textView.responseLbl.text = entries[indexPath.row]
            cell.textView.questionLbl.text = questions[indexPath.row]
            
            var localDate = dates[indexPath.row].components(separatedBy: " ")
            
            cell.dateView.dayLbl.text = localDate[0]
            cell.dateView.monthLbl.text = self.convertDate(dateNum: localDate[1])
            
            
            if(indexPath.row >= 1){
                
                if (dates[indexPath.row] == dates[indexPath.row-1]) {
                    
                    //var localDate = dates[indexPath.row].components(separatedBy: " ")
                    cell.dateView.dayLbl.text = ""
                    cell.dateView.monthLbl.text = ""
                    //cell.dateView.dayLbl.text = localDate[0]
                    //cell.dateView.monthLbl.text = convertDate(dateNum: localDate[1])
                    //cell.dateView.dayLbl.isHidden = true
                    //cell.dateView.monthLbl.isHidden = true
                    print("HERE1")
                    print(dates)
                
                }
                
                else {
                    var localDate = dates[indexPath.row].components(separatedBy: " ")
                    
                    cell.dateView.dayLbl.text = localDate[0]
                    cell.dateView.monthLbl.text = convertDate(dateNum: localDate[1])
                    cell.dateView.dayLbl.isHidden = false
                    cell.dateView.monthLbl.isHidden = false
                    print(cell.dateView.dayLbl.text)
                    print(cell.dateView.monthLbl.text)
                    
                    //print("here2")
                    //print(dates)
                    //UserDefaults.standard.set(0, forKey: "qindex")
                }
            }
            
            else{
                //cell.dateView.dayLbl.isHidden = false
                //cell.dateView.monthLbl.isHidden = false
                var localDate = dates[indexPath.row].components(separatedBy: " ")
                cell.dateView.dayLbl.text = localDate[0]
                cell.dateView.monthLbl.text = convertDate(dateNum: localDate[1])
                
                //UserDefaults.standard.set(0, forKey: "qindex")
                //print("here3")
                //print(dates)
            }
 
            cell.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellViewTapped))
            cell.addGestureRecognizer(tapGesture)
            
            return cell
        }
 
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell") as! JournalTableViewCell
            
            // put question here
            if  (getQIndex() > 5){
                cell.textView.responseLbl.text = ""
            }
            else{
                cell.textView.responseLbl.text = "Tap to answer"
            }
            cell.textView.questionLbl.text = self.questProgression[getQIndex()]
            
            cell.position = indexPath.row

            cell.dateView.isHidden = false
            cell.dateView.dayLbl.text = ""
            cell.dateView.monthLbl.text = ""
            
            
            if dates.count != 0{
                var localDate = dates[indexPath.row-1].components(separatedBy: " ")
                
                if self.getDate() != dates[dates.count-1] {
                    UserDefaults.standard.set(0, forKey: "qindex")
                }
            }
            
            
            cell.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellViewTapped))
            cell.addGestureRecognizer(tapGesture)
            
            
            return cell
        }
    }
    
    func convertDate(dateNum: String) -> String{
        var yearString = ""
        
        switch (dateNum) {
        case "1":
            yearString = "Jan"
        case "2":
            yearString = "Feb"
        case "3":
            yearString = "Mar"
        case "4":
            yearString = "Apr"
        case "5":
            yearString = "May"
        case "6":
            yearString = "June"
        case "7":
            yearString = "Jul"
        case "8":
            yearString = "Aug"
        case "9":
            yearString = "Sept"
        case "10":
            yearString = "Oct"
        case "11":
            yearString = "Nov"
        case "12":
            yearString = "Dec"
        default:
            yearString = "error"
        }
        
        return yearString
    }
    
    
    func cellViewTapped(sender:UITapGestureRecognizer) {
        
        let view = sender.view as! JournalTableViewCell
        let index = view.position
        
        //print(index == self.entries.count)
        //print(getQIndex())
        
        // open editor to edit journal entry
        // TODO
        
        if (index == self.entries.count) {
            
            print(getQIndex())
            
            if (getQIndex() == 0){
            
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "safePlaceNav") //as! safePlaceViewController
                present(VC!, animated: true, completion: nil)
            }
            if (getQIndex() == 1){
                
                let VC2 = self.storyboard?.instantiateViewController(withIdentifier: "smileNav") //as! safePlaceViewController
                present(VC2!, animated: true, completion: nil)
            }
            
            if (getQIndex() == 2){
                let VC3 = self.storyboard?.instantiateViewController(withIdentifier: "moodNav") //as! safePlaceViewController
                present(VC3!, animated: true, completion: nil)
            }
            
            if (getQIndex() == 3){
                let VC4 = self.storyboard?.instantiateViewController(withIdentifier: "dissociationNav") //as! safePlaceViewController
                present(VC4!, animated: true, completion: nil)
            }
            
            if (getQIndex() == 4){
                let VC5 = self.storyboard?.instantiateViewController(withIdentifier: "anxietyNav") //as! safePlaceViewController
                present(VC5!, animated: true, completion: nil)
            }
            
            if (getQIndex() == 5){
                let VC6 = self.storyboard?.instantiateViewController(withIdentifier: "depressedNav") //as! safePlaceViewController
                present(VC6!, animated: true, completion: nil)
            }
            
            if (getQIndex() >= 6){
            }
            
        }
        
        else{
            
        }
        
        
    }
    
    func getQIndex() -> Int {
        return UserDefaults.standard.integer(forKey: "qindex")
    }
    
    // I want to add another table cell to the end of the journal, one that has:
    // a quuestion label, and method of answering
    // and then it saves that to the journal as a regular cell (in the entries, dates, and questions array)
    // and generates a new table cell
    // the way of filling in is generated based on a specific class, cant do it with storyboard, I will have to do it programatically in order to allow each form to be different based on the question
    
    // How do I want to organize these questions and answers to these questions?
    // Array with each question in order, possibly an index that increases with each question being posted to remember what to post
    // when clicked, it will get the index, point to an array of either identifiers for view controllers or viewcontroller names, and then create a new view with that indentifier progromatically
    // Look up how to create segues progromatically and do unwind segues progromatically to save the data to the journal
    
    
    // make the qindex reset everytime there is a new date
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
