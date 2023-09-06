//
//  BookTableRepository.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/06.
//

import Foundation
import RealmSwift

class BookTableRepository {
    
    private let realm = try! Realm()
    
    
    /// 전체 데이터 불러오기
    func fetch() -> Results<BookTable> {
        let data = realm.objects(BookTable.self).sorted(byKeyPath: "price", ascending: false)
        print("해당 파일 경로", realm.configuration.fileURL)
        return data
    }
    
    
    /// DB 데이터 저장하기
    /// - Parameter item: 만들어진 RealmModel 설정
    func creatItem(item: BookTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    
    /// DB 데이터 삭제하기
    /// - Parameter item: 삭제되는 RealmModel 설정
    func deleteItem(item: BookTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            
        }
    }
    
    
    /// DB에서 필터하기
    /// - Returns: DB에서 필터 된 값 리턴
    func fetchFilter() -> Results<BookTable> {
        let result = realm.objects(BookTable.self).where {
            $0.bookTitle.contains("성공", options: .caseInsensitive)
        }
        return result
    }
    
    func updateItem(book: BookTable, text: String) {
        
        
        
        
        
        
        let item = BookTable(value: ["_id": book._id,
                                     "bookTitle": book.bookTitle,
                                     "author": book.author,
                                     "bookThumbnail": book.bookThumbnail,
                                     "price": book.price,
                                     "memoText": text])
       
        
        do {
            // 트랜잭션에게 값 전달
            try realm.write {
                // modified : 수정하면서 업데이트
                realm.add(item, update: .modified)
            }
        } catch {
            print(error)
        }
        
    }
}
