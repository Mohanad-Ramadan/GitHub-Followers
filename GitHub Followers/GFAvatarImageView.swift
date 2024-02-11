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
    
    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else {return}
            guard error == nil else {return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            guard let data = data else {return}
            
            guard let image = UIImage(data: data) else {return}
            
            DispatchQueue.main.async {
                strongSelf.image = image
            }
        }
        task.resume()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
