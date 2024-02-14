//
//  GFFollowerItemVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 14/02/2024.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemCyan, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.getFollowersDidTapped(user: user)
    }
    
//    func forceIgnorButton() {
//        actionButton.
//    }

}
