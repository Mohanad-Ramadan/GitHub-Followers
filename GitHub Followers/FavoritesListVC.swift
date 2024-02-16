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
            guard let self = self else {return}
            
            switch favorites {
            case .success(let favorites):
                if favorites.isEmpty{
                    showEmptyStateView(with: "No Favorites added yet.", superView: view.self)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.favoriteTable.reloadData()
                        self.view.bringSubviewToFront(self.favoriteTable)
                    }
                }
            case .failure(let failure):
                self.presentGFAlertOnMainThread(alertTitle: "Opps!", messageText: "Something went wrong.", buttonTitle: "Ok")
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let favorite = favorites[indexPath.row]
//        let vc = FollowersListVC()
//        vc.username = favorite.login
//        vc.title = favorite.login
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard editingStyle == .delete else {return}
//
//    }
    
}

