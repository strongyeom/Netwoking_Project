//
//  KakoBookVCViewController.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/09.
//

import UIKit
import Alamofire
import SwiftyJSON

class KakoBookVCViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var bookList: [KakoBook] = []
    
    var searchList: [KakoBook] = []
    
    // var searchString: String = "성공"
    
    @IBOutlet var kakaoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "카카오 책 검색"
        searchList = bookList
        settingInitial()
        settingCollectionViewLayout()
        settingSearchBar()
        callRequest()
    }
    
    func settingInitial() {
       
        kakaoCollectionView.delegate = self
        kakaoCollectionView.dataSource = self
        
        let nib = UINib(nibName: KakaoCollectionViewCell.identifier, bundle: nil)
        
        kakaoCollectionView.register(nib, forCellWithReuseIdentifier:  KakaoCollectionViewCell.identifier)
    }
    
    func settingSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "도서를 검색해주세요"
    }
    func settingCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 5)
        layout.itemSize = CGSize(width: width / 3 , height: width / 2.5 )
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        kakaoCollectionView.collectionViewLayout = layout
    }
  
    
    func callRequest(text: String = "성공") {
        searchList.removeAll()
        
        let textASCII = "\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v3/search/book?query=\(textASCII)&size=30"
        let header: HTTPHeaders = ["Authorization" : APIKey.KakoKey]
        print("url",url)
        AF.request(url, method: .get, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("json",json)
                for item in json["documents"].arrayValue {
                    let imageTitle = item["thumbnail"].stringValue
                    let bookname = item["title"].stringValue
                    let data = KakoBook(imageUrl: imageTitle, bookTitle: bookname)
                    self.searchList.append(data)
                    self.kakaoCollectionView.reloadData()
                }
                
                if json["meta"]["total_Count"].intValue < 1 {
                    print("검색 결과 없음")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension KakoBookVCViewController : UICollectionViewDelegate {
    
}

extension KakoBookVCViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KakaoCollectionViewCell.identifier, for: indexPath) as? KakaoCollectionViewCell else { return UICollectionViewCell() }
        
        let item = searchList[indexPath.item]
        
        cell.configure(item: item)
        return cell
    }
    
}
extension KakoBookVCViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        callRequest(text: text)
        kakaoCollectionView.reloadData()
        searchBar.text = ""
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        callRequest(text: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchList = bookList
        searchBar.text = ""
        view.endEditing(true)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}
