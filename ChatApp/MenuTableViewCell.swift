//
//  MenuTableViewCell.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 28/01/22.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var lblMenuName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
