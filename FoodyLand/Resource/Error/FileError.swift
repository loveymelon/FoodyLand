//
//  FileError.swift
//  FoodyLand
//
//  Created by 김진수 on 11/7/24.
//

import Foundation

enum FileError: Error {
    case saveError
    case fileRemoveError
    case fileNoExist
    case dataError
    case noDocument
}
