//
//  GFFollowerItemVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 14/02/2024.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
    func getFollowersDidTapped(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    init(for user: User, delegate: GFFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemCyan, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.getFollowersDidTapped(for: user)
    }
    
    
    weak var delegate: GFFollowerItemVCDelegate!
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
