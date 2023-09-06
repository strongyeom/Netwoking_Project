//
//  RealMModel.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/04.
//

import Foundation
import RealmSwift

class BookTable: Object {
   @Persisted(primaryKey: true) var _id: ObjectId
    // version 6 - 컬럼명 변경
   @Persisted var bookName: String
   @Persisted var author: List<String>
   @Persisted var price: Int
    // version 3 - 컬럼명 변경
   @Persisted var thumbnail: String?
   @Persisted var memoText: String?
    // version 1 - 추가
    // version 2 - 삭제
  // @Persisted var like: Bool
    
    // version 4 - 추가
    @Persisted var count: Int
    // version 5 - 병합
    @Persisted var titleSummery: String
    
    @Persisted var firstCount: Int
    
    convenience init(bookTitle: String, author: List<String>, price: Int, bookThumbnail: String? = nil, memoText: String? = nil) {
        self.init()
        self.bookName = bookTitle
        self.author = author
        self.price = price
        self.thumbnail = bookThumbnail
        self.memoText = memoText
       // self.like = false
        self.count = 100
        self.titleSummery = "제목은 '\(bookTitle)' 이고, 내용은 '\(memoText ?? "비어있습니다.")' 입니다."
        self.firstCount = 100
    }
}
