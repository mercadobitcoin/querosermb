//
//  URLSessionExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

extension URLSession {
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask {
        let task = self.dataTask(with: url) { data, _, error in
            // Imprimir qualquer erro
            if let error = error {
                print("Failed to fetch image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to create image from data")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
        return task
    }
}
