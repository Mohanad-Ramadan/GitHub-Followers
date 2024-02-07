//
//  FollowersListVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 07/02/2024.
//

import UIKit

class FollowersListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    var username: String!

}
