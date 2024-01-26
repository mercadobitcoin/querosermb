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
}

struct BinanceSymbol: Decodable {
    let symbolIdExchange: String
    let assetIdBase: String
    let assetIdQuote: String
}
