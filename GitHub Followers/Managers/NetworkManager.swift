//
//  NetworkManager.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 08/02/2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSObject, UIImage>()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            return try self.decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    func getUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if (error != nil) {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let user = try self.decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let imageCached = cache.object(forKey: urlString as NSObject){
            completion(imageCached)
            return
        }
        
        guard let url = URL(string: urlString) else { completion(nil) ;return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse,response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey:  urlString as NSObject)
            completion(image)
        }
        task.resume()
    }
    
}
