//
//  FavoritesListVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 07/02/2024.
//

import UIKit

class FavoritesListVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavorites()
    }
    
    private func configureVC(){
        view.backgroundColor = .systemBlue
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(favoriteTable)
        favoriteTable.frame = view.bounds
        favoriteTable.delegate = self
        favoriteTable.dataSource = self
    }
    
    private func getFavorites() {
        PresistenceManager.retrieveFavorites { [weak self] favorites in
            guard let self else {return}
            
            switch favorites {
            case .success(let favorites):
                updateFavoriteListWith(favorites)
            case .failure(_):
                self.presentGFAlert(messageText: "Something went wrong.")
            }
        }
        
        func updateFavoriteListWith(_ favorites: [Follower]) {
            if favorites.isEmpty{
                showEmptyStateViewWith(message: "No Favorites added yet.", superView: view)
            } else {
                self.favorites = favorites
                DispatchQueue.main.async {
                    self.favoriteTable.reloadData()
                    self.view.bringSubviewToFront(self.favoriteTable)
                }
            }
        }
        
    }
    
    private let favoriteTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        table.rowHeight = 80
        table.separatorStyle = .none
        return table
    }()

    var favorites = [Follower]()
    
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let vc = FollowersListVC(username: favorite.login)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return}
        
        PresistenceManager.updateFavoritesWith(action: .remove, user: favorites[indexPath.row]) { [weak self] error in
            guard let self else {return}
            
            guard error != nil else {
                self.favorites.remove(at: indexPath.row)
                favoriteTable.deleteRows(at: [indexPath], with: .left)
                if favorites.isEmpty {
                    self.showEmptyStateViewWith(message: "No Favorites added yet.", superView: view)
                }
                return
            }
            self.presentGFAlert(messageText: "Unable to remove the favorite")
        }
    }
    
}

