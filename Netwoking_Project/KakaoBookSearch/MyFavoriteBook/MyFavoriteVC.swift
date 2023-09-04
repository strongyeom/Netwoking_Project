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
        
        let realm = try! Realm()
        
        tasks = realm.objects(BookTable.self)
        print(tasks)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("화면 전환 - viewWillAppear")
        self.favoriteTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("화면 전환 - viewWillDisappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("화면 전환 - viewDidAppear")
    }
    
    func setNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked(_:)))
    }
    
    @objc func plusButtonClicked(_ sender: UIBarButtonItem) {
        print("MyFavoriteVC - plusButtonClicked")
       
        let sb = UIStoryboard(name: "KakoBookVC", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: KakoBookVCViewController.identifier) as? KakoBookVCViewController else { return }
        
        
        
        
        
//        present(vc, animated: true)
        present(vc, animated: true) {
            print("화면전환 - Present")
        }
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
        
        let aa =  row.author.map { String($0)}
        for author in aa {
            cell.bookAuthor.text = author
        }
        
        let url = URL(string: row.bookThumbnail!)!
        cell.bookThumbnail.kf.setImage(with: url)
        cell.bookPrice.text = "\(row.price)원"
        cell.bookTitle.text = row.bookTitle
        
        return cell
    }
}
