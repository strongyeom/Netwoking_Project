//
//  Ext+UIViewController.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/05.
//

import UIKit

extension UIViewController {
    
    
    // MARK: - 도큐먼트 폴더에서 이미지 삭제 메서드
    func removeImageToDocument(fileName: String) {
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // 2. 경로 찾기
        let fileUrl = documnentDirectory.appendingPathComponent(fileName)
       
        do {
            try FileManager.default.removeItem(atPath: fileUrl.path)
        } catch {
            
        }
    }
    
    
    // MARK: - 도큐먼트 폴더에서 이지미 불러오기
    func loadImageToDocument(fileName: String) -> UIImage {
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "flame")! }
        // 2. 경로 찾기
        let fileUrl = documnentDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            return UIImage(contentsOfFile: fileUrl.path)!
        } else {
            return UIImage(systemName: "flame")!
        }
    }
    
    // MARK: - 도큐먼트 폴더에 이미지 파일 저장하는 메서드
    func saveImageFileToDocument(fileName: String, image: UIImage) {
        
        // 1. 도큐먼트 폴더 경로 찾기
        guard let documnentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // 2. 경로 찾기
        let fileUrl = documnentDirectory.appendingPathComponent(fileName)
        print("fileUrl",fileUrl)
        // 3. 이미지 변환
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 4. 이미지 저장
        do {
            try data.write(to: fileUrl)
            print("document에 생성된 사진 주소 : \(data)")
        } catch {
            print(error)
        }
    }
}
