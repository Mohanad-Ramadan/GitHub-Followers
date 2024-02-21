//
//  GFButton.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 07/02/2024.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(color: UIColor , title: String){
        self.init(frame: .zero)
        set(color: color, title: title)
    }
    
    func set(color: UIColor, title: String ){
        configuration?.title = title
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
    }
    
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
