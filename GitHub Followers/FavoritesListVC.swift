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
        view.backgroundColor = .systemBlue
        
        PresistenceManager.retrieveFavorites { [weak self] favorites in
            guard let self = self else {return}
            
            switch favorites {
            case .success(let success):
                <#code#>
            case .failure(let failure):
                <#code#>
            }
        }
    }

}
