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
    
    func downloadImage(from urlString: String) {
        if let imageCached = cache.object(forKey: urlString as NSObject){
            self.image = imageCached
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {return}
            guard error == nil else {return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            guard let data = data else {return}
            
            guard let image = UIImage(data: data) else {return}
            self.cache.setObject(image, forKey:  urlString as NSObject)
            
            DispatchQueue.main.async {self.image = image}
            
        }
        
        task.resume()
        
    }
    
    let cache = NetworkManager.shared.cache
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
