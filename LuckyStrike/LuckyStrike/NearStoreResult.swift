//
//  PlaceStruct.swift
//  LuckyStrike
//
//  Created by 수현 on 2022/02/23.
//

import Foundation

// MARK: - Welcome
struct NearStoreResult: Codable {
    let meta: Meta
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let roadAddress: RoadAddress
    let address: Address

    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
        case address
    }
}

// MARK: - Address
struct Address: Codable {
    let addressName: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
    }
}

// MARK: - RoadAddress
struct RoadAddress: Codable {
    let addressName: String
    let roadName: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case roadName = "road_name"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}
