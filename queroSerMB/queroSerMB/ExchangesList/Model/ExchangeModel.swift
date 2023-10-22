//
//  ExchangeListModel.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import Foundation

struct ExchangeModel: Decodable {
    let name: String?
    let exchangeId: String?
    let dailyVolumeUsd: Double?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case exchangeId = "exchange_id"
        case dailyVolumeUsd = "volume_1day_usd"
    }
}

struct ExchangeLogoModel: Decodable {
    let exchangeId: String?
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case exchangeId = "exchange_id"
        case url = "url"
    }
}
