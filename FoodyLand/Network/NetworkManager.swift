//
//  NetworkManager.swift
//  FoodyLand
//
//  Created by 김진수 on 3/10/24.
//

import Alamofire

enum NetworkManager {
    
    case searchKeyword(String, Int, Int)
    
    private var baseURL: String {
        return "https://dapi.kakao.com/v2/local/"
    }
    
    var endPoint: String {
        switch self {
        case .searchKeyword(let text, let page, let item):
            return baseURL + "search/keyword?query=\(text)&page=\(page)&size=\(item)"
        }
    }
    
    var headers: HTTPHeaders {
        return ["Authorization": APIKey.kakaoKey]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var urlEncoding: URLEncoding {
        switch self {
        case .searchKeyword:
            return URLEncoding(destination: .queryString)
        }
    }
}
