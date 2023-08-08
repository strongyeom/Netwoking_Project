//
//  BeerViewController.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class BeerViewController: UIViewController {
    
    var beerList: [Beer] = []
    
    @IBOutlet var collectionBg: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView()
        callRequest()
        settingCollectionView()
        settingCollectionViewLayout()
    }
    
    func settingTableView() {
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        let nib = UINib(nibName: TableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableViewCell.identifier)
        
    }
    
    func settingCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: CollectionViewCell.identifier, bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
    }
    
    func settingCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let spacing: CGFloat = 5
        let width = UIScreen.main.bounds.width
        let height = collectionBg.frame.height // height: 300
        print("height 계산 기존 \(height) 결과값 : \((height - (spacing * 4)) / 3)")
        layout.itemSize = CGSize(width: width, height: (height - (spacing * 4)) / 3)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
        collectionView.collectionViewLayout = layout
        
    }
    
    // 네트워크 통신
    func callRequest() {
        
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json.arrayValue {
                    
                    let imageData = item["image_url"].stringValue
                    let title = item["name"].stringValue
                    let description = item["description"].stringValue
                    let data = Beer(ImageUrl: imageData, title: title, description: description)
                    self.beerList.append(data)
                }
                self.tableView.reloadData()
                self.collectionView.reloadData()
               // print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
  
}


// MARK: - UITableViewDelegate
extension BeerViewController: UITableViewDelegate {
    
}


// MARK: - UITableViewDataSource
extension BeerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView - numberOfRowsInSection")
        return beerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView - cellForRowAt")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        let row = beerList[indexPath.row]
        cell.configure(row: row)
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension BeerViewController: UICollectionViewDelegate {

}


// MARK: - UICollectionViewDataSource
extension BeerViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView - numberOfItemsInSection")
        return beerList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView - cellForItemAt")
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        let item = beerList[indexPath.item]
        cell.configure(item: item)

        return cell
    }

}

