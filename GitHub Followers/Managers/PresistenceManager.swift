//
//  PresistenceManager.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 15/02/2024.
//

import Foundation

enum PresistenceActionType {
    case add, remove
}


enum PresistenceManager {
    static let defualt = UserDefaults.standard
    
    enum Keys {
        static let favoriteToDefualt = "addToFavorites"
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let retrievedFavorites = defualt.object(forKey: Keys.favoriteToDefualt) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: retrievedFavorites)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToGetFavoriote))
        }
    }
    
    
    static func save(favorite: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let newfavorite = try encoder.encode(favorite)
            defualt.setValue(newfavorite, forKey: Keys.favoriteToDefualt)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
    static func updateFavoritesWith(action: PresistenceActionType,user selectedUser: Follower, completion: @escaping (GFError?) -> Void) {
        
        retrieveFavorites { result in
            switch result {
            case .success(let retrievedFavorites):
                var allFavorites = retrievedFavorites
                
                switch action {
                case .add:
                    guard !allFavorites.contains(selectedUser) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    allFavorites.append(selectedUser)
                case .remove:
                    allFavorites.removeAll { $0.login == selectedUser.login}
                }
                
                completion(save(favorite: allFavorites))

            case .failure(_):
                completion(.unableToFavorite)
            }
        }
    }
    
}
