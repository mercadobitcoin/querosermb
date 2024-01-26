//
//  ExchangeCellViewModel.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//
import UIKit

class ExchangeCellViewModel {
    
    // MARK: - Properties
    private var task: URLSessionDataTask?
    static private var imageCache: [URL: UIImage] = [:]
    
    let name: String
    let id: String
    let dailyVolumeUsdText: String
    var exchangeIconURL: URL?
    var exchangeIconImage: UIImage? {
        didSet {
            onLogoImageUpdated?(exchangeIconImage)
        }
    }
    var hasAttemptedToDownloadImage: Bool = false
    var onLogoImageUpdated: ((UIImage?) -> Void)?
    
    // MARK: - Initializers
    init(from model: ExchangeModel, logoUrl: URL?) {
        name = model.name ?? "Desconhecido"
        id = "ID: \(model.exchangeId ?? "Desconhecido")"
        
        let volume = model.dailyVolumeUsd ?? 0
        dailyVolumeUsdText = NumberFormatter.financial.string(fromValue: volume)
        
        exchangeIconURL = logoUrl
        exchangeIconImage = ExchangeCellViewModel.cachedImage(for: logoUrl) ?? UIImage(named: "dollarLogo")?.withTintColor(.blue)
    }
    
    // MARK: - Image Handling
    func fetchImage(from logoUrl: URL?) {
        guard let logoUrl = logoUrl else { return }
        
        if let cachedImage = ExchangeCellViewModel.imageCache[logoUrl] {
            self.exchangeIconImage = cachedImage
            return
        }
        
        task = URLSession.shared.fetchImage(from: logoUrl) { [weak self] image in
            if let image = image {
                ExchangeCellViewModel.imageCache[logoUrl] = image
            }
            self?.exchangeIconImage = image
        }
    }
    
    func cancelImageDownload() {
        task?.cancel()
    }
    
    // MARK: - Private Helpers
    static private func cachedImage(for url: URL?) -> UIImage? {
        guard let url = url else { return nil }
        return imageCache[url]
    }
}
