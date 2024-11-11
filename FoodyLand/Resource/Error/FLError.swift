//
//  FLError.swift
//  FoodyLand
//
//  Created by 김진수 on 11/7/24.
//

import Foundation

enum FLError {
    case networkError(NetworkError)
    case realmError(RealmError)
    case fileError(FileError)
    case unowned(Error)
    case none
}
