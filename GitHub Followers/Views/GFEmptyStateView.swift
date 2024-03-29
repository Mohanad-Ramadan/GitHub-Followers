//
//  GFEmptyStateView.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 13/02/2024.
//

import UIKit

class GFEmptyStateView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
        configure()
    }
    
    private func configure() {
        addSubview(messageLabel)
        addSubview(logoImageView)
        
        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: labelCenterYConstant),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: logoBottomConstant)
        ])
        
    }
    
    let messageLabel : UILabel = {
        let label = GFTitleLabel(textAlignment: .center,fontSize: 28)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .emptyStateLogo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
