//
//  URLSessionExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

extension URLSession {
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask {
        let task = self.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
        return task
    }
}
