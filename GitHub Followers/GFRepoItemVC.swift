//
//  GFRepoItemVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 14/02/2024.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    

}
