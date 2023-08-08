//
//  TableViewCell.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    @IBOutlet var beerImage: UIImageView!
    
    @IBOutlet var beerTitle: UILabel!
    
    @IBOutlet var beerDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
