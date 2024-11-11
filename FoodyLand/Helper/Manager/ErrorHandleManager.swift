//
//  ErrorHandleManager.swift
//  FoodyLand
//
//  Created by 김진수 on 11/11/24.
//

import Foundation

final class ErrorHandleManager {
    
    static let shared = ErrorHandleManager()
    
    private init() { }
    
    func errorHandle(_ error: Error) -> FLError {
        if let netError = error as? NetworkError {
            return FLError.networkError(netError)
        } else if let realmError = error as? RealmError {
            return FLError.realmError(realmError)
        } else if let fileError = error as? FileError {
            return FLError.fileError(fileError)
        } else {
            return FLError.unowned(error)
        }
    }
}
