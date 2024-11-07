//
//  AddressModel.swift
//  FoodyLand
//
//  Created by 김진수 on 11/7/24.
//

import Foundation

struct Address: Hashable, Decodable {
    let id = UUID() // 값이 같을때의 충돌을 막기위해서
    let addressName: String
    let addId: String
    let phone: String
    let placeName: String
    let placeURL: String
    let roadAddress: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case addId = "id"
        case phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddress = "road_address_name"
        case x
        case y
    }
}
