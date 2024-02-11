//
//  UIHelper.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 11/02/2024.
//

import UIKit

class UIHelper {
    
    static func collectionThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumSpacing: CGFloat = 10
        let avatarsRowWidth = width - padding*2 - minimumSpacing*2
        let itemWidth = avatarsRowWidth / 3
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowlayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowlayout
    }
    
}
