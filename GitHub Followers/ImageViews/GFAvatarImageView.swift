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
        image = UIImage(resource: .avatarPlaceholder)
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImageFrom(_ url: String){
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else {return}
            DispatchQueue.main.async { self.image = image }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
