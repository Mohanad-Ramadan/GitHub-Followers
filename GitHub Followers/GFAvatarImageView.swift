//
//  GFAvatarImageView.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 10/02/2024.
//

import UIKit

class GFAvatarImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        layer.cornerCurve = .continuous
        image = UIImage(resource: .avatarPlaceholder)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
