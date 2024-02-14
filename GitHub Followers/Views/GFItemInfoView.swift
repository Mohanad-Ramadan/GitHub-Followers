//
//  GFItemInfoView.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 14/02/2024.
//

import UIKit

class GFItemInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    private func configure() {
        [ symbolImageView, titleLabel, countLabel].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
    
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image   = UIImage(systemName: "folder")
            titleLabel.text         = "Public Repos"
        case .gists:
            symbolImageView.image   = UIImage(systemName: "text.alignleft")
            titleLabel.text         = "Public Gists"
        case .followers:
            symbolImageView.image   = UIImage(systemName: "text.alignleft")
            titleLabel.text         = "Followers"
        case .following:
            symbolImageView.image   = UIImage(systemName: "person.2")
            titleLabel.text         = "Following"
        }
        
        countLabel.text             = String(count)
    }
    
    let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        return imageView
    }()
    
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ItemInfoType {
    case repos, gists, followers, following
}
