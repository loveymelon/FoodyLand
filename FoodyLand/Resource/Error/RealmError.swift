//
//  RealmError.swift
//  FoodyLand
//
//  Created by 김진수 on 11/7/24.
//

import Foundation

enum RealmError: Error {
    case createFail
    case updateFail
    case deleteFail
    case noData
    case unknownError
}
