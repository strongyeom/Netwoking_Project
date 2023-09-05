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
    
    
    let realm = try! Realm()
    
    var tasks: Results<BookTable>!
    
    let toolbar = UIToolbar()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        settup()
        // viewDidLoad()에서 realm을 만들어 빈값을 넣어준다.
        // 왜냐하면... delegate가 먼저 타기 때문에 nil 발생함
        
        tasks = realm.objects(BookTable.self)
        print(realm.configuration.fileURL)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favoriteTableView.reloadData()
    }

    func setNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked(_:)))
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
       // print("tasks \(tasks)")
        
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
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cancel = UIContextualAction(style: .destructive, title: "삭제") { action, _, _ in
            
            let data = self.tasks[indexPath.row]
            
            self.removeImageToDocument(fileName: "\(data._id).jpg")
            do {
                try self.realm.write {
                    self.realm.delete(data)
                }
            } catch {
                
            }
            self.favoriteTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [cancel])
    }
}
