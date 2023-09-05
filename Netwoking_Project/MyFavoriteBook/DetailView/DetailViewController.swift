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
        // let saveData = UserDefaults.standard.string(forKey: "memoText")
        memoTextView.settingTextView(text: data.memoText )
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
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnClicked(_:)))
        let removeButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(removeBtnClicked(_:)))
        
        let barItems = [flexibleSpace, flexibleSpace, editButton, removeButton]
        // 버튼 아이템들을 넣어줍니다.
        self.toolbarItems = barItems
       
    }
     
    @objc func editBtnClicked(_ sender: UIBarButtonItem) {
        // Realm Update - 해당 record를 업데이트 하는 것
        guard let data else { return }
        let item = BookTable(value: ["_id": data._id,
                                     "bookTitle": memoTextView.text!,
                                     "author": data.author,
                                     "bookThumbnail": data.bookThumbnail,
                                     "price": data.price,
                                     "memoText": memoTextView.text!])
       
        
        do {
            // 트랜잭션에게 값 전달
            try realm.write {
                // modified : 수정하면서 업데이트
                realm.add(item, update: .modified)
            }
        } catch {
            print(error)
        }
     
        
        navigationController?.popViewController(animated: true)
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
