//
//  NetworkManager.swift
//  Live It
//
//  Created by Muniyaraj on 29/08/24.
//

import Foundation
import Combine

final class NetworkManager{
    
    public func performRequest<T: Decodable>(with request: URLRequest)-> AnyPublisher<T, Error>{
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ output in
                guard let httpResponse = output.response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else{
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    deinit {
        debugPrint("\(String(describing: self)) deinited...")
    }
}
