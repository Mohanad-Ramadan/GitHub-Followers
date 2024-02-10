//
//  FollowersCell.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 10/02/2024.
//

import UIKit

class FollowersCell: UICollectionViewCell {
    static let identifier = "FollowersCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    private func configureViews(){
        addSubview(avatarImageView)
        addSubview(usernameLabel)
    }
    
    func set(follower: Follower){
        usernameLabel.text = follower.login
    }
    
    private func applyConstraints(){
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
