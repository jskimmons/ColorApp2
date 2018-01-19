//
//  JournalTableViewCell.swift
//  CVTest
//
//  Created by Joseph Skimmons on 8/27/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

import UIKit

class JournalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textView: journalEntryView!

    @IBOutlet weak var dateView: DateView!
    
    var position: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.layer.masksToBounds = false
        self.textView.layer.shadowRadius = 3.0
        self.textView.layer.shadowColor = UIColor.black.cgColor
        self.textView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.textView.layer.shadowOpacity = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
