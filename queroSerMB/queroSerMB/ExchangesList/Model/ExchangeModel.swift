//
//  ExchangeListModel.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import Foundation

struct ExchangeModel: Decodable, Equatable {
    let name: String?
    let exchangeId: String?
    let hourVolumeUsd: Double?
    let dailyVolumeUsd: Double?
    let monthVolumeUsd: Double?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case exchangeId = "exchange_id"
        case hourVolumeUsd = "volume_1hrs_usd"
        case dailyVolumeUsd = "volume_1day_usd"
        case monthVolumeUsd = "volume_1mth_usd"
    }
}

struct ExchangeLogoModel: Decodable, Equatable {
    let exchangeId: String?
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case exchangeId = "exchange_id"
        case url = "url"
    }
}
