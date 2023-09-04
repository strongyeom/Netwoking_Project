//
//  MyFavoriteVC.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/04.
//

import UIKit
import RealmSwift
import Kingfisher

class MyFavoriteVC: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var tasks: Results<BookTable>!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        settup()
        // viewDidLoad()에서 realm을 만들어 빈값을 넣어준다.
        // 왜냐하면... delegate가 먼저 타기 때문에 nil 발생함
        let realm = try! Realm()
        tasks = realm.objects(BookTable.self)
        print(tasks)
    }
    
    func setNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked(_:)))
    }
    
    @objc func plusButtonClicked(_ sender: UIBarButtonItem) {
        print("MyFavoriteVC - plusButtonClicked")
        
        let sb = UIStoryboard(name: "KakoBookVC", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: KakoBookVCViewController.identifier) as? KakoBookVCViewController else { return }
        
        
        vc.completionHandler = { result in
            self.tasks = result
            self.favoriteTableView.reloadData()
        }
        present(vc, animated: true)
    }
    
    func settup() {
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        favoriteTableView.rowHeight = 120
        let nib = UINib(nibName: MyFavoriteBookTableViewCell.identifier, bundle: nil)
        favoriteTableView.register(nib, forCellReuseIdentifier: MyFavoriteBookTableViewCell.identifier)
    }
    
}

extension MyFavoriteVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tasks \(tasks)")
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoriteBookTableViewCell.identifier, for: indexPath) as? MyFavoriteBookTableViewCell else { return UITableViewCell() }
        // authors는 cell이 생성되고 종료될때까지만 주기를 나타내야함... 프로퍼티로 지정되면 계속 쌓이기 때문에 관리 할 수 없음
        var authors: [String] = []
        let row = tasks[indexPath.row]
        
        // String으로 형 변환
        let transferString = row.author.map { String($0)}
        
        for author in transferString {
            authors.append(author)
        }
        
        let commaSeparatedString = authors.joined(separator: ", ")
        
        print("어떻게 담김? \(commaSeparatedString)")
        cell.bookAuthor.text = commaSeparatedString
        let url = URL(string: row.bookThumbnail!)!
        cell.bookThumbnail.kf.setImage(with: url)
        cell.bookPrice.text = "\(row.price)원"
        cell.bookTitle.text = row.bookTitle
        
        
        return cell
    }
}
