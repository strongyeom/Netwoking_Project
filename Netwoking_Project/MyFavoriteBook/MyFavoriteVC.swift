//
//  MyFavoriteVC.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/04.
//

import UIKit
import RealmSwift

class MyFavoriteVC: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!

    var tasks: Results<BookTable>!
   
    let bookRepository = BookTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        settup()
        // viewDidLoad()에서 realm을 만들어 빈값을 넣어준다.
        // 왜냐하면... delegate가 먼저 타기 때문에 nil 발생함
        tasks = bookRepository.fetch()
        bookRepository.checkShemaVersion()
        
    }

    func setNavigationButton() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked(_:))),UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(editBtnClicked(_:)))]

    }
    
    @objc func editBtnClicked(_ sender: UIBarButtonItem) {
        print("수정 버튼 눌림")
        
        self.tasks = bookRepository.fetchFilter()
        
        self.favoriteTableView.reloadData()
    }
    
    @objc func plusButtonClicked(_ sender: UIBarButtonItem) {
        print("MyFavoriteVC - plusButtonClicked")
        
        let sb = UIStoryboard(name: "KakoBookVC", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: KakoBookVCViewController.identifier) as? KakoBookVCViewController else { return }
        
        
        vc.completionHandler = {
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

        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoriteBookTableViewCell.identifier, for: indexPath) as? MyFavoriteBookTableViewCell else { return UITableViewCell() }

        
        let row = tasks[indexPath.row]
        cell.bookThumbnail.image = loadImageToDocument(fileName: "\(row._id).jpg")
        cell.configure(row: row)
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tasks[indexPath.row]
        
        let sb = UIStoryboard(name: "MyFavoriteVC", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else { return }
        vc.data = row
        vc.completionHandler = {
            self.favoriteTableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cancel = UIContextualAction(style: .destructive, title: "삭제") { action, _, _ in
            
            let data = self.tasks[indexPath.row]
            
            self.removeImageToDocument(fileName: "\(data._id).jpg")
            self.bookRepository.deleteItem(item: data)
            self.favoriteTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [cancel])
    }
}
