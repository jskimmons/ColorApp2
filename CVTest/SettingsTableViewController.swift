
//
//  SettingsTableViewController.swift
//  CVTest
//
//  Created by Joseph Skimmons on 6/19/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var phraseTF: UITextField!
    @IBOutlet weak var bdayPick: UIDatePicker!
    @IBOutlet weak var bdayDisplay: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var anxietyS: UISwitch!
    @IBOutlet weak var dissociationS: UISwitch!
    @IBOutlet weak var depressionS: UISwitch!
    
    @IBAction func bdayPickAction(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let strDate = dateFormatter.string(from: bdayPick.date)
        self.bdayDisplay.text = strDate
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (UserDefaults.standard.bool(forKey: "launchedBefore") == false){
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            let alertOKAction=UIAlertAction(title:"Ok!", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            var alert = UIAlertController(title: "Welcome!",
                                          message: "Enter your personal info before you begin",
                                          preferredStyle: .alert)
            alert.addAction(alertOKAction)
            
            self.present(alert, animated: true, completion:nil)
        }
        
        
    }
    
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //self.bdayPick.setDate(bdayPick.date, animated: false)
        //TODO ^^
        
        if self.revealViewController() != nil {
            //menuButton.target = self.revealViewController()
            //menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let defaults = UserDefaults.standard
        
        if let phrase = defaults.string(forKey: "phrase") {
            DispatchQueue.main.async {
                self.phraseTF.text = phrase
            }
        }
        
        // WHAT THE FUCK FIGURE THIS SHIT OUT BRO
        if let bDayDate = defaults.object(forKey: "bdayDate") as! Date? {
            DispatchQueue.main.async {
                self.bdayPick.date = bDayDate
            }
        }
        
        if let lastName = defaults.string(forKey: "lastName") {
            DispatchQueue.main.async {
                self.lastNameTF.text = lastName
            }
        }
        else{
            defaults.set("", forKey: "lastName")
        }
        if let firstName = defaults.string(forKey: "firstName") {
            DispatchQueue.main.async {
                self.firstNameTF.text = firstName
            }
        }
        else{
            defaults.set("", forKey: "firstName")
        }
        if let bday = defaults.string(forKey: "bday") {
            DispatchQueue.main.async {
                self.bdayDisplay.text = bday
            }
            
        }

        
        if(defaults.bool(forKey: "anxiety") == true){
            DispatchQueue.main.async {
                self.anxietyS.setOn(true, animated: false)
            }
        }
        else{
            DispatchQueue.main.async {
                self.anxietyS.setOn(false, animated: false)
            }
        }
        
        if(defaults.bool(forKey: "dissociation") == true){
            DispatchQueue.main.async {
                self.dissociationS.setOn(true, animated: false)
            }
        }
        else{
            DispatchQueue.main.async {
                self.dissociationS.setOn(false, animated: false)
            }
        }
        
        if(defaults.bool(forKey: "depression") == true){
            DispatchQueue.main.async {
                self.depressionS.setOn(true, animated: false)
            }
        }
        else{
            DispatchQueue.main.async {
                self.depressionS.setOn(false, animated: false)
            }
        }
        
        
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
        
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        segue.destination.transitioningDelegate = self.transitionManager
    }
 


}
