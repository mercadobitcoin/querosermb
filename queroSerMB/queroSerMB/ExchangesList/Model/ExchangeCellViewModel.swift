//
//  ExchangeCellViewModel.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//
import UIKit

class ExchangeCellViewModel {
    var task: URLSessionDataTask?
    var onLogoImageUpdated: ((UIImage?) -> Void)?
    let name: String
    let dailyVolumeUsdText: String
    var exchangeIconURL: URL?
    var exchangeIconImage: UIImage?
    var hasAttemptedToDownloadImage: Bool = false
    
    var shouldDownloadImage: Bool = false {
        didSet {
            if shouldDownloadImage, let logoUrl = exchangeIconURL {
                downloadImage(from: logoUrl)
            }
        }
    }

    init(from model: ExchangeModel, logoUrl: URL?) {
        self.name = model.name ?? "Desconhecido"
        self.exchangeIconURL = logoUrl
        
        if let volume = model.dailyVolumeUsd {
            self.dailyVolumeUsdText = NumberFormatter.financial.string(fromValue: volume)
        } else {
            self.dailyVolumeUsdText = "$0"
        }

        self.exchangeIconURL = logoUrl
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.fetchImage(from: url) { [weak self] image in
            self?.exchangeIconImage = image
            self?.onLogoImageUpdated?(image)
        }
    }
    
    func fetchImage(from logoUrl: URL?) {
        guard let logoUrl = logoUrl else { return }
        task = URLSession.shared.fetchImage(from: logoUrl) { [weak self] image in
            self?.exchangeIconImage = image
            self?.onLogoImageUpdated?(image)
        }
    }
    
    func cancelImageDownload() {
        task?.cancel()
    }
}
