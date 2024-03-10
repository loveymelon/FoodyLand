//
//  NetworkError.swift
//  FoodyLand
//
//  Created by 김진수 on 3/9/24.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case KeyError
    case Auth
    case overCount
    case severError
    case systemError
    case systemCheck
    case invalidStatusCode(Int)
    case unknow
}
