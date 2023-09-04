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
   @Persisted var bookTitle: String
   @Persisted var author: List<String>
   @Persisted var price: Int
   @Persisted var bookThumbnail: String?
    
    convenience init(bookTitle: String, author: List<String>, price: Int, bookThumbnail: String? = nil) {
        self.init()
        self.bookTitle = bookTitle
        self.author = author
        self.price = price
        self.bookThumbnail = bookThumbnail
    }
}
