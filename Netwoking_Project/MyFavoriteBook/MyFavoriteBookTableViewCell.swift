//
//  MyFavoriteBookTableViewCell.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/04.
//

import UIKit
import Kingfisher

class MyFavoriteBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookThumbnail: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookTitle.font = .systemFont(ofSize: 20, weight: .medium)
        bookPrice.font = .systemFont(ofSize: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(row: BookTable) {
        // authors는 cell이 생성되고 종료될때까지만 주기를 나타내야함... 프로퍼티로 지정되면 계속 쌓이기 때문에 관리 할 수 없음
        var authors: [String] = []
        // String으로 형 변환
        let transferString = row.author.map { String($0)}
        
        for author in transferString {
            authors.append(author)
        }
        
        let commaSeparatedString = transferString.joined(separator: ", ")
        
      // print("어떻게 담김? \(commaSeparatedString)")
        self.bookAuthor.text = commaSeparatedString
        let url = URL(string: row.bookThumbnail!)!
        self.bookThumbnail.kf.setImage(with: url)
        self.bookPrice.text = "\(row.price)원"
        self.bookTitle.text = row.bookTitle
    }
    
}
