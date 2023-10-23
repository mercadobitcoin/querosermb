//
//  OHLCVModel.swift
//  queroSerMB
//
//  Created by Matheus Perez on 22/10/23.
//

import Foundation

struct OHLCVData: Decodable {
    let timePeriodStart: Date
    let timePeriodEnd: Date
    let timeOpen: Date?
    let timeClose: Date?
    let priceOpen: Double?
    let priceHigh: Double?
    let priceLow: Double?
    let priceClose: Double?
    let volumeTraded: Double?
    let tradesCount: Int?
    let crypto: String?

    enum CodingKeys: String, CodingKey {
        case timePeriodStart = "time_period_start"
        case timePeriodEnd = "time_period_end"
        case timeOpen = "time_open"
        case timeClose = "time_close"
        case priceOpen = "price_open"
        case priceHigh = "price_high"
        case priceLow = "price_low"
        case priceClose = "price_close"
        case volumeTraded = "volume_traded"
        case tradesCount = "trades_count"
        case crypto = "type"
    }
}

struct Symbol: Decodable {
    let symbolId: String
    let assetBase: String
    let assetQuote: String

    enum CodingKeys: String, CodingKey {
        case symbolId = "symbol_id"
        case assetBase = "asset_id_base"
        case assetQuote = "asset_id_quote"
    }
}

struct BinanceSymbol: Decodable {
    let symbol_id_exchange: String
    let asset_id_base: String
    let asset_id_quote: String
}
