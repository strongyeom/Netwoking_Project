//
//  KakoBook.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/08/09.
//

import Foundation

//struct KakoBook {
//    var imageUrl: String
//    var bookTitle: String
//}

// MARK: - KakaoBook
struct KakaoBook: Codable {
    var documents: [Document]
    let meta: Meta
}

// MARK: - Document
struct Document: Codable {
    let thumbnail: String
    let title: String
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
