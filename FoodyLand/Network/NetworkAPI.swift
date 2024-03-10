//
//  NetworkAPI.swift
//  FoodyLand
//
//  Created by 김진수 on 3/8/24.
//

import Alamofire

typealias NetworkResult<T> =  Result<T, NetworkError>

class NetworkAPI {
    
    static let shared = NetworkAPI()
    
    private init() { }
    
    func fetchKeyword<T: Decodable>(type: T.Type, api: NetworkManager, completionHandler: @escaping (NetworkResult<T>) -> Void) {
        
        AF.request(api.endPoint, method: api.method, encoding: api.urlEncoding, headers: api.headers).responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let success):
                completionHandler(.success(success))
            case .failure(let failure):
                print(failure)
                if let statusCode = response.response?.statusCode {
                    
                    switch statusCode {
                    case 400:
                        completionHandler(.failure(.badRequest))
                    case 401:
                        completionHandler(.failure(.KeyError))
                    case 403:
                        completionHandler(.failure(.Auth))
                    case 429:
                        completionHandler(.failure(.overCount))
                    case 500:
                        completionHandler(.failure(.severError))
                    case 502:
                        completionHandler(.failure(.systemError))
                    case 503:
                        completionHandler(.failure(.systemCheck))
                    default:
                        completionHandler(.failure(.invalidStatusCode(statusCode)))
                    }
                    
                } else {
                    completionHandler(.failure(.unknow))
                }
            }
        }
    }
    
    
}
