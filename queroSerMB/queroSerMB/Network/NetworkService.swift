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
}

class NetworkService: NetworkServiceProtocol {
    
    private let baseURLString = "https://rest.coinapi.io/v1"
    private let apiKey = "3807A772-1841-409F-B8DA-5A2E2110A687"
    
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
}

