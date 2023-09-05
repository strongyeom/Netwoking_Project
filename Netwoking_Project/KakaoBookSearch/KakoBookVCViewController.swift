//
//  KakoBookVCViewController.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/09.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class KakoBookVCViewController: UIViewController {
    
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var searchBookCount: UILabel!
    var bookList: KakaoBook = KakaoBook(documents: [], meta: Meta(isEnd: true, pageableCount: 0, totalCount: 0))

    var page: Int = 1
    
    var isEnd: Bool = false
    
    var pageableCount: Int = 0

    
    // 경로 찾기
    let realm = try! Realm()
    
  //  var completionHandler: ((Results<BookTable>) -> Void)?
    
    var completionHandler: (() -> Void)?

    
    @IBOutlet var kakaoCollectionView: UICollectionView!
    
    // indicator 생성
    let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "카카오 책 검색"
        settingInitial()
        settingCollectionViewLayout()
        settingSearchBar()
        callRequest(page: page, isEnd: isEnd)
        searchBookCount.text = "도서 검색 \(pageableCount)개"
     
    }
    
    func settingInitial() {
       
        kakaoCollectionView.delegate = self
        kakaoCollectionView.dataSource = self
       // kakaoCollectionView.prefetchDataSource = self
        let nib = UINib(nibName: KakaoCollectionViewCell.identifier, bundle: nil)
        
        kakaoCollectionView.register(nib, forCellWithReuseIdentifier:  KakaoCollectionViewCell.identifier)
        
        // nib을 연결하는 것이 아니라 footer 설정시 collectionView와 footer를 연결하는 과정
        kakaoCollectionView.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewFooterView.identifier)
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
        // collectonView bottom indicator layout
        layout.footerReferenceSize = CGSize(width: kakaoCollectionView.bounds.width, height: 50)
        kakaoCollectionView.collectionViewLayout = layout
    }
  
    
    func callRequest(text: String = "성공", page: Int, isEnd: Bool) {
        //self.bookList.removeAll()
        print("바닥일때 추가됌")
        let textASCII = "\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v3/search/book?query=\(textASCII)&size=15&page=\(page)&is_end=\(isEnd)"
        let header: HTTPHeaders = ["Authorization" : APIKey.KakoKey]
        
        print("url",url)
        
        AF.request(url, method: .get, headers: header).validate()
            .responseDecodable(of: KakaoBook.self) { result in
                
                switch result.result {
                case .success(let data):
                    self.bookList.documents.append(contentsOf: data.documents)
                case .failure(let error):
                    print(error)
                }
                
                self.kakaoCollectionView.reloadData()
            }
    }
}




// MARK: - UICollectionViewDataSource
extension KakoBookVCViewController: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         if kind == UICollectionView.elementKindSectionFooter {
             let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterView.identifier, for: indexPath)
             footer.addSubview(footerView)
             footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
             footerView.color = .red
             return footer
         }
         return UICollectionReusableView()
     }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KakaoCollectionViewCell.identifier, for: indexPath) as? KakaoCollectionViewCell else { return UICollectionViewCell() }
        let item = bookList.documents[indexPath.item]
        
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = bookList.documents[indexPath.item]

        let transferString = List<String>()
        transferString.append(objectsIn: selectedItem.authors)
        // 식판 만들기 : 어떤 요소로 구성할 것인지
        let task = BookTable(bookTitle: selectedItem.title, author: transferString, price: selectedItem.price, bookThumbnail: selectedItem.thumbnail, memoText: "")
        
        let cell = collectionView.cellForItem(at: indexPath) as! KakaoCollectionViewCell
        
        saveImageFileToDocument(fileName: "\(task._id).jpg", image: cell.bookImage.image!)
        // 파일매니저 디렉토리 인식
        
        try! realm.write {
            realm.add(task)
            print("Realm Add Succeed")
        }
       
        completionHandler?()
        dismiss(animated: true)
        
    }
    
    
    
}


// MARK: - UICollectionViewDataSourcePrefetching
extension KakoBookVCViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("UICollectionViewDataSourcePrefetching")
       
        // 응답 메세지로 page에 대한 값이 정해져 있다면 조건을 추가해준다.
        // 또한 마지막 페이지가 나오면 더이상 page를 증가시키지 않는다.
        for indexPath in indexPaths {
            
            if bookList.documents.count - 1 == indexPath.row && page < 50 && isEnd == false {
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
        self.bookList.documents = []
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
        print("offset",offset)
        print("scrollViewHeight",scrollViewHeight)
        print("doneScrollOffSet",doneScrollOffSet)
        print("targetContentOffset.y",targetPointOfy)
    
        if targetPointOfy + 40 >= doneScrollOffSet {
            print("바닥이다")
            page += 1
            callRequest(page: page, isEnd: isEnd)
            // indicator 시작
            footerView.startAnimating()
            
            // 메인 뷰 ( 사용자에게 보여지는 화면 ) 몇 초 후 딜레이를 줄 것 인지
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self else { return }
                // 몇 초 후에 indicator 애니메이션 중지
                footerView.stopAnimating()
                print("1초 뒤 ")
                // 현재 스크롤 포인트에서 설정된 데이터 통신 값 불러오기
                callRequest(page: page, isEnd: isEnd)
                
            }
        }
    }
}
