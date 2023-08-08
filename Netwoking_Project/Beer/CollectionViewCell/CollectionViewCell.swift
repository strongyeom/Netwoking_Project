//
//  CollectionViewCell.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "CollectionViewCell"
    @IBOutlet var headerCollImage: UIImageView!
    
    @IBOutlet var headerCollTitle: UILabel!
    
    @IBOutlet var headerCollDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.headerCollDesc.settingDescrition()
    }
    
    func settingKingfisher(urlString: String) {
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: headerCollImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        headerCollImage.kf.indicatorType = .activity
        headerCollImage.kf.setImage(
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
    
    func configure(item: Beer) {
        self.headerCollTitle.text = item.title
        self.headerCollDesc.text = item.description
        settingKingfisher(urlString: item.ImageUrl)
    }

}
