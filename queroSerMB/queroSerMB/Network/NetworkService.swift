//
//  NetworkService.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

protocol NetworkServiceProtocol {
    func getExchangeList(completion: @escaping (Result<[ExchangeModel], Error>) -> Void)
    func getExchangeLogos(completion: @escaping (Result<[ExchangeLogoModel], Error>) -> Void)
    func getOHLCVForMajorPairs(_ exchangeId: String, baseAsset: String, completion: @escaping (Result<[OHLCVData], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    private let baseURLString = "https://rest.coinapi.io/v1"
    private let apiKey = "ED1DAC3A-A510-488D-9B60-3E3D47A2C6C6"
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
    func getExchangeList(completion: @escaping (Result<[ExchangeModel], Error>) -> Void) {
        let urlString = "\(baseURLString)/exchanges"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "NetworkServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nenhum dado recebido."])
                DispatchQueue.main.async {
                    completion(.failure(noDataError))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let exchanges = try decoder.decode([ExchangeModel].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(exchanges))
                }
            } catch let parseError {
                DispatchQueue.main.async {
                    completion(.failure(parseError))
                }
            }
        }
        
        task.resume()
    }
    
    func getExchangeLogos(completion: @escaping (Result<[ExchangeLogoModel], Error>) -> Void) {
        let urlString = "\(baseURLString)/exchanges/icons/32"
        
        guard let url = URL(string: urlString) else {
            let invalidURLError = NSError(domain: "NetworkServiceError", code: 2, userInfo: [NSLocalizedDescriptionKey: "URL Inválida."])
            DispatchQueue.main.async {
                completion(.failure(invalidURLError))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                let dataError = NSError(domain: "NetworkServiceError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Dados não recebidos corretamente."])
                DispatchQueue.main.async {
                    completion(.failure(dataError))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let logos = try decoder.decode([ExchangeLogoModel].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(logos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getOHLCVForMajorPairs(_ exchangeId: String, baseAsset: String, completion: @escaping (Result<[OHLCVData], Error>) -> Void) {
        fetchBinanceSymbols(for: exchangeId) { result in
            switch result {
            case .success(let symbols):
                let majorQuoteAssets = ["USDC"]
                
                let filteredSymbols = symbols.filter {
                    baseAsset == $0.asset_id_base && majorQuoteAssets.contains($0.asset_id_quote)
                }
                
                guard !filteredSymbols.isEmpty else {
                    let error = NSError(domain: "NetworkServiceError", code: 5, userInfo: [NSLocalizedDescriptionKey: "Nenhum par principal encontrado para \(exchangeId)."])
                    completion(.failure(error))
                    return
                }
                
                let periodId = "1HRS"
                let timeEnd = Date()
                let timeStart = Calendar.current.date(byAdding: .day, value: -1, to: timeEnd)!
                
                var ohlcvDataList = [OHLCVData]()
                let dispatchGroup = DispatchGroup()
                
                for symbol in filteredSymbols {
                    dispatchGroup.enter()
                    
                    let formattedTimeStart = self.dateFormatter.string(from: timeStart)
                    let formattedTimeEnd = self.dateFormatter.string(from: timeEnd)
                    let ohlcvURLString = "\(self.baseURLString)/ohlcv/\(exchangeId)_SPOT_\(symbol.asset_id_base)_\(symbol.asset_id_quote)/history?period_id=\(periodId)&time_start=\(formattedTimeStart)&time_end=\(formattedTimeEnd)"
                    
//                    if baseAsset == "ETH" {
//                        ohlcvURLString = "https://rest.coinapi.io/v1/ohlcv/BINANCE_SPOT_ETH_USDC/history?period_id=1HRS&time_start=2023-10-21T19:34:53.0940000Z&time_end=2023-10-22T19:34:53.0940000Z"
//                    } else {
//                        ohlcvURLString = "https://rest.coinapi.io/v1/ohlcv/BINANCE_SPOT_BTC_USDC/history?period_id=1HRS&time_start=2023-10-21T19:34:53.0940000Z&time_end=2023-10-22T19:34:53.0940000Z"
//                    }
                    var ohlcvRequest = URLRequest(url: URL(string: ohlcvURLString)!)
                    ohlcvRequest.addValue(self.apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
                    
                    let ohlcvTask = URLSession.shared.dataTask(with: ohlcvRequest) { data, _, _ in
                        if let data = data {
                            do {
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                                let ohlcvData = try decoder.decode([OHLCVData].self, from: data)
                                ohlcvDataList.append(contentsOf: ohlcvData)
                            } catch let decodeError {
                                print("Decoding error: \(decodeError)")
                            }
                        }
                        dispatchGroup.leave()
                    }
                    ohlcvTask.resume()
                }
                
                dispatchGroup.notify(queue: .main) {
                    if ohlcvDataList.isEmpty {
                        let error = NSError(domain: "NetworkServiceError", code: 6, userInfo: [NSLocalizedDescriptionKey: "Não foi possível obter os dados de OHLCV para os principais pares."])
                        completion(.failure(error))
                    } else {
                        completion(.success(ohlcvDataList))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension NetworkService {
    func fetchBinanceSymbols(for exchangeId: String, completion: @escaping (Result<[BinanceSymbol], Error>) -> Void) {
        let urlString = "\(baseURLString)/symbols/\(exchangeId)"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "NetworkServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nenhum dado recebido."])
                DispatchQueue.main.async {
                    completion(.failure(noDataError))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let symbols = try decoder.decode([BinanceSymbol].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(symbols))
                }
            } catch let parseError {
                DispatchQueue.main.async {
                    completion(.failure(parseError))
                }
            }
        }
        
        task.resume()
    }
}
