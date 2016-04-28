//
//  MapTableViewCell.swift
//  On The Map
//
//  Created by Erick Manrique on 4/24/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {

    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentMediaLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(studentFirstName:String, studentLastName: String, studentLink: String){
        self.studentNameLabel.text = "\(studentFirstName) \(studentLastName)"
        self.studentMediaLink.text = studentLink
    }
    
}
