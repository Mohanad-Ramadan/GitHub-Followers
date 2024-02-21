//
//  GFRepoItemVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 14/02/2024.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func githubProfilDidTapped(for user: User)
}

class GFRepoItemVC: GFItemInfoVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    init(for user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.githubProfilDidTapped(for: user)
    }
    
    
    weak var delegate: GFRepoItemVCDelegate!
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
