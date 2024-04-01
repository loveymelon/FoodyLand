//
//  FileManager+Extension.swift
//  FoodyLand
//
//  Created by 김진수 on 3/17/24.
//

import UIKit

enum FileError: Error {
    case saveError
    case fileRemoveError
    case fileNoExist
    case dataError
    case noDocument
}

typealias FileResult = Result<Void, FileError>

extension UIViewController {
    // !!!
    //
    func saveImageToDocument(image: UIImage, fileName: String, imageName: String) -> FileResult {
        
        // 마켓 고유 아이디로 파일명을 잡고 이미지 이름은 이미지 테이블에서 생기는 고유 아이도.jpg로 생성
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return .failure(.noDocument) }
        
        let directoryURL = documentDirectory.appendingPathComponent(fileName)
        
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
            } catch {
                return .failure(.fileNoExist)
            }
        }
        
        let fileURL = directoryURL.appendingPathComponent("\(imageName).jpg")
        
        guard let data = image.jpegData(compressionQuality: 1) else { return .failure(.dataError) } // 용량을 낮추는 대신 데이터의 손실이 발생함 pngData가 비손실 그래픽임
        
        do {
            try data.write(to: fileURL)
        } catch {
            return .failure(.saveError)
        }
        return .success(())
    }
    
    func loadImageToDocument(imageName: String, fileName: String) -> Result<UIImage, FileError> {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return .failure(.noDocument) }
        
        print(documentDirectory)
        
        let directoryURL = documentDirectory.appendingPathComponent(String(fileName))
        
        let fileURL = directoryURL.appendingPathComponent("\(imageName).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            
            guard let image = UIImage(contentsOfFile: fileURL.path) else { return .failure(.dataError) }
            
            return .success(image)
        } else {
            return .success(UIImage.basic)
        }
        
    }
    
    func removeImageFromDocument(imageName: String, fileName: String, noData: Bool) -> FileResult {
        // viewModel에서 repository로 이미지 값이 있는지 없는지 체크 후 없다면 파일 자체를 삭제
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return .failure(.noDocument) }
        
        let directoryURL = documentDirectory.appendingPathComponent(fileName)
        
        let fileURL = directoryURL.appendingPathComponent("\(imageName).jpg")
        
        print("1231231231212", fileURL)
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            
            do {
                try FileManager.default.removeItem(at: fileURL)
                
                if noData {
                    try FileManager.default.removeItem(at: directoryURL)
                }
                
            } catch {
                return .failure(.fileRemoveError)
            }
            
        } else {
            return .failure(.fileNoExist)
        }
        
        return .success(())
    }
    
    func removeImageFile(fileName: String) -> FileResult {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return .failure(.noDocument) }
        
        let directoryURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            if FileManager.default.fileExists(atPath: directoryURL.path()) {
                try FileManager.default.removeItem(at: directoryURL)
            }
        } catch {
            return .failure(.fileNoExist)
        }
        
        return .success(())
    }
}
