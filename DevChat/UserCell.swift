//
//  UserCell.swift
//  DevChat
//
//  Created by Apostolos Chalkias on 08/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLbl: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
        //Set default checkmark
        setCheckMark(selected: false)
        
    }

    func updateUI(user: User){
        firstNameLbl.text = user.firstName
    }

    func setCheckMark(selected: Bool) {
        //Set the image acordignly whether is checked or not
        let imageStr = selected ? "messageindicatorchecked1" : "messageindicator1"
        self.accessoryView = UIImageView(image: UIImage(named: imageStr))
    }

}
