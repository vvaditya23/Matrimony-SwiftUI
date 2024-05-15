//
//  NetworkManager.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 05/05/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://randomuser.me/api/"
    private var seed: String? // Store the seed for pagination
    
    func fetchRandomProfiles(page: Int, resultsPerPage: Int, gender: String, completion: @escaping (Result<[RandomProfile], Error>) -> Void) {
        var urlString = "\(baseURL)?page=\(page)&results=\(resultsPerPage)&gender=\(gender)"
        
        // Append seed parameter for pagination
        if let seed = seed {
            urlString += "&seed=\(seed)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(Error.self as! Error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(Error.self as! Error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RandomProfileResponse.self, from: data)
                
                // Store the seed for pagination
                if self.seed == nil {
                    self.seed = response.info.seed
                }

                
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func resetSeed() {
        seed = nil
    }
}
