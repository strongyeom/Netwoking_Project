//
//  MyFavoriteVC.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/04.
//

import UIKit

class MyFavoriteVC: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        settup()
    }
    
    func setNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked(_:)))
    }
    
    @objc func plusButtonClicked(_ sender: UIBarButtonItem) {
        print("MyFavoriteVC - plusButtonClicked")
       
        let sb = UIStoryboard(name: "KakoBookVC", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: KakoBookVCViewController.identifier) as? KakoBookVCViewController else { return }
        
        
        
        
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoriteBookTableViewCell.identifier, for: indexPath) as? MyFavoriteBookTableViewCell else { return UITableViewCell() }
        //
        
        return cell
    }
}
