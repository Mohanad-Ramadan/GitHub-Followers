//
//  UserInfoVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 13/02/2024.
//

import UIKit

class UserInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneNavButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
         
        navigationItem.rightBarButtonItem = doneNavButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

    var username: String!
    
}
