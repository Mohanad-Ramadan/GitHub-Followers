//
//  FollowersListVC.swift
//  GitHub Followers
//
//  Created by Mohanad Ramdan on 07/02/2024.
//

import UIKit

class FollowersListVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureViews()
        getFollowers()
        configureCollectionDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureViews(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.collectionThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
    }
    
    func configureCollectionDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as? FollowerCell
            cell?.set(follower: follower)
            return cell
            
        })
    }
    
    func updateCollectionData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
            guard let strongSelf = self else {return}
            
            switch result {
            case .success(let followers):
                strongSelf.followers = followers
                strongSelf.updateCollectionData()
            case .failure(let error):
                strongSelf.presentGFAlertOnMainThread(alertTitle: "Opps!", messageText: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    var followers = [Follower]()
    var username: String!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    enum Section { case main }
    
}
