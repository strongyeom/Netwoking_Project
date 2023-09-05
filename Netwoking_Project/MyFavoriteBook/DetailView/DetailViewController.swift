//
//  DetailViewController.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/05.
//

import UIKit
import Kingfisher
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailAuthor: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    
    
    var data: BookTable?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Data",data!)
        settup()
        setupToolBar()
        setupToolBarButton()
    }
    
    func settup() {
        guard let data else { return }
        let url = URL(string: data.bookThumbnail!)!
        detailImageView.kf.setImage(with: url)
        detailTitle.text = data.bookTitle
        detailAuthor.text = listToString(data: data)
        
    }
    
    func listToString(data: BookTable) -> String {
        var authors: [String] = []
        // String으로 형 변환
        let transferString = data.author.map { String($0)}
        
        for author in transferString {
            authors.append(author)
        }
        
        let commaSeparatedString = transferString.joined(separator: ", ")
        return commaSeparatedString
    }
    func setupToolBar() {
        // true로 투명하게 되어있는 것을 false로 설정
        navigationController?.isToolbarHidden = false
        // bar 모양 설정
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemOrange
        navigationController?.toolbar.scrollEdgeAppearance = appearance
    }
    
    func setupToolBarButton() {
        // 아이템에 따라 균등하게 분배
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        let removeButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(removeBtnClicked(_:)))
        
        let barItems = [flexibleSpace, flexibleSpace, editButton, removeButton]
        // 버튼 아이템들을 넣어줍니다.
        self.toolbarItems = barItems
        
        // 버튼을 변경할 때 부드러운 애니메이션효과와 같이 사용하고 싶다면 이런 메서드도 있어요. (대신 사용 시 barItems이 변해야 겠죠?)
        // self.setToolbarItems(barItems, animated: true)
    }
    
    @objc func removeBtnClicked(_ sender: UIBarButtonItem) {
        print("삭제 버튼 눌림 ")
        guard let data else { return }
        self.removeImageToDocument(fileName: "\(data._id).jpg")
        
        do {
            try self.realm.write {
                self.realm.delete(data)
            }
        } catch {
            
        }
        
        navigationController?.popViewController(animated: true)
    }
}
