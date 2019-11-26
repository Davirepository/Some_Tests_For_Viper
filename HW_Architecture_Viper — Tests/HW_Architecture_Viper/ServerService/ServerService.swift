//
//  ServerService.swift
//  HW_Architecture_Viper
//
//  Created by Давид on 31/10/2019.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class ServerService: ImageServerSideProtocol {
    
    private var session: URLSessionProtocol
    init(withSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func downloadImage(imageURL: String?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        //        print("get from internet")
        
        guard let imageURL = imageURL, let url = URL(string:imageURL) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let currentError = error {
                completion(nil, nil, currentError)
                return
            }
            if let currentData = data, let response = response {
                // load in cach
                self.handleLoadedImage(data: currentData, response: response)
                completion(currentData, response, nil)
            } else if let currentData = data {
                completion(currentData, nil, nil)
            } else {
                return
            }
        }
        
        task.resume()
    }
    
    func loadFromCach(url: String?) -> Data? {
        guard let imageURL = url, let url = URL(string: imageURL) else { return nil }
        //проверяем на налиие в кэше
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            //            print("from cache")
            return cachedResponse.data
        }
        return nil
    }
    
    // загрузка в кэш
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        // ответ на запрос
        let cachedResponse = CachedURLResponse(response: response, data: data)
        // передаем ответ в хранилище
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    // удаление из кэша
    func deleteLoadedImage() {
        //        print("clean cach")
        // удаляем из хранилища
        URLCache.shared.removeAllCachedResponses()
        print(URLCache.shared.currentDiskUsage)
    }
    
}
