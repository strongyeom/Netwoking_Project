//
//  TableViewCell.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    @IBOutlet var beerImage: UIImageView!
    
    @IBOutlet var beerTitle: UILabel!
    
    @IBOutlet var beerDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    func configure(row: Beer) {
        self.beerTitle.text = row.title
        self.beerDescription.text = row.description
        settingKingfisher(urlString: row.ImageUrl)
    }
    
    func settingKingfisher(urlString: String) {
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: beerImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        beerImage.kf.indicatorType = .activity
        beerImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
