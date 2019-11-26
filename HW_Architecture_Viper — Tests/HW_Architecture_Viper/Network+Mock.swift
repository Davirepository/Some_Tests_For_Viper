//
//  Network+Mock.swift
//  HW_Architecture_Viper
//
//  Created by Давид on 26/11/2019.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let block: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.block = completion
    }
    func resume() {
        block()
    }
}


// MARK: - URLSession

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol   {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}


class MockURLSession: URLSessionProtocol {
    var data: Data?
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let data = self.data
        return MockURLSessionDataTask {
            completionHandler(data, nil, nil)
        }
    }
    
}
