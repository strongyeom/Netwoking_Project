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
    
    @IBOutlet var searchBookCount: UILabel!
    var bookList: [KakoBook] = []

    var page: Int = 1
    
    var isEnd: Bool = false
    
    var pageableCount: Int = 0
    
   
    let indicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet var kakaoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "카카오 책 검색"
        settingInitial()
        settingCollectionViewLayout()
        settingSearchBar()
        callRequest(page: page, isEnd: isEnd)
        searchBookCount.text = "도서 검색 \(pageableCount)개"
       
        indicator.tintColor = .red
        self.kakaoCollectionView.addSubview(indicator)
        
    }
    
    func settingInitial() {
       
        kakaoCollectionView.delegate = self
        kakaoCollectionView.dataSource = self
       // kakaoCollectionView.prefetchDataSource = self
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
  
    
    func callRequest(text: String = "성공", page: Int, isEnd: Bool) {
        //self.bookList.removeAll()
        print("바닥일때 추가됌")
        let textASCII = "\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v3/search/book?query=\(textASCII)&size=15&page=\(page)&is_end=\(isEnd)"
        let header: HTTPHeaders = ["Authorization" : APIKey.KakoKey]
        
        print("url",url)
        
        AF.request(url, method: .get, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
               // print("json",json)
                
                self.pageableCount = json["meta"]["pageable_count"].intValue
                // print("callRequest - pageableCount",self.pageableCount)
              
                for item in json["documents"].arrayValue {
                    let imageTitle = item["thumbnail"].stringValue
                    let bookname = item["title"].stringValue
                   
                    let data = KakoBook(imageUrl: imageTitle, bookTitle: bookname)
                   
                    self.bookList.append(data)
                }
                
                self.searchBookCount.text = "\(text) 검색 수 : \(self.pageableCount)개"
                
                self.kakaoCollectionView.reloadData()
               
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension KakoBookVCViewController : UICollectionViewDelegate {
    // 스크롤 하는 중일때 실시간으로 반영하는 방법은 없을까?
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let contentSize = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        
        //contentOffSet 도 스크롤한 길이를 나타내지만 실시간으로 반영해주진 않는다.
        let offset = scrollView.contentOffset.y
        
        // targetContentOffset.pointee.y: 사용자가 스크롤하면 실시간으로 값을 나타낼 수 있음
        let targetPointOfy = targetContentOffset.pointee.y
        
        let doneScrollOffSet = contentSize - scrollViewHeight
        print("contentSize",contentSize)
        print("offset ",offset)
        print("scrollViewHeight",scrollViewHeight)
        print("doneScrollOffSet",doneScrollOffSet)
        print("targetContentOffset.y",targetPointOfy)
    
        if targetPointOfy + 40 >= doneScrollOffSet {
            print("바닥이다")
            page += 1
            callRequest(page: page, isEnd: isEnd)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension KakoBookVCViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KakaoCollectionViewCell.identifier, for: indexPath) as? KakaoCollectionViewCell else { return UICollectionViewCell() }
        
        let item = bookList[indexPath.item]
        
        cell.configure(item: item)
        return cell
    }
    
}


// MARK: - UICollectionViewDataSourcePrefetching
extension KakoBookVCViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("UICollectionViewDataSourcePrefetching")
        // 응답 메세지로 page에 대한 값이 정해져 있다면 조건을 추가해준다.
        // 또한 마지막 페이지가 나오면 더이상 page를 증가시키지 않는다.
        for indexPath in indexPaths {
            if self.bookList.count-1 == indexPath.row && page < 50 && isEnd == false {
                page += 1
                callRequest(page: page, isEnd: isEnd)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("취소 됨 \(indexPaths)")
    }
    
    
}




// MARK: - UISearchBarDelegate
extension KakoBookVCViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        page = 1
        self.bookList.removeAll()
        callRequest(text: text, page: page, isEnd: isEnd)
        print("pageableCount",pageableCount)
        searchBar.text = ""
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        
        searchBar.text = ""
        callRequest(page: page, isEnd: isEnd)
        view.endEditing(true)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}
