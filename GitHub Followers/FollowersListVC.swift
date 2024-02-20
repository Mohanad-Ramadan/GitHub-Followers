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
        configureCollectionView()
        configureSearchController()
        getFollowers(page: 1)
        configureCollectionDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    init(username: String!) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFavorite))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addFavorite() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {return}
            self.dissmisLoadingView()
            
            switch result {
            case .success(let user):
                addToFavoriteWith(user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(alertTitle: "Opps!", messageText: error.rawValue, buttonTitle: "Ok")
            }
        }
        
        func addToFavoriteWith(_ user: User){
            let selectedUser = Follower(login: user.login, avatarUrl: user.avatarUrl)
            
            PresistenceManager.updateFavoritesWith(action: .add, user: selectedUser) { error in
                guard let error = error else {
                    self.presentGFAlertOnMainThread(alertTitle: "Done!", messageText: "This user is added to your favorites", buttonTitle: "Ok")
                    return
                }
                self.presentGFAlertOnMainThread(alertTitle: "Opps!", messageText: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func getFollowers(page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {return}
            
            dissmisLoadingView()
            
            switch result {
            case .success(let followers):
                updateFollowersWith(followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(alertTitle: "Opps!", messageText: error.rawValue, buttonTitle: "OK")
            }
        }
        
        func updateFollowersWith(_ followers: [Follower]){
            if followers.count < 100 { thereIsMoreFollowers = false }
            self.followers.append(contentsOf: followers)
            
            if self.followers.isEmpty {
                DispatchQueue.main.async {
                    self.showEmptyStateView(with: "This user hasn't any followers. Go follow them 😅.", superView: self.view)
                }
                return
            }
            self.updateCollectionData(with: self.followers)
        }
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.collectionThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func configureCollectionDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as? FollowerCell
            cell?.set(follower: follower)
            return cell
            
        })
    }
    
    func updateCollectionData(with followers: [Follower]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }

    var username: String!
    var currentFollowerPage = 1
    var thereIsMoreFollowers = true

    var followers = [Follower]()
    var searchedFollowers = [Follower]()
    var isStillSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    
    enum Section { case main }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - CollectionView Delegate
extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollOffest = scrollView.contentOffset.y + view.frame.height
        let contentOffest = scrollView.contentSize.height
        
        if scrollOffest > contentOffest, thereIsMoreFollowers, !isLoadingMoreFollowers {
            currentFollowerPage += 1
            getFollowers(page: currentFollowerPage)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = isStillSearching ? searchedFollowers[indexPath.item] : followers[indexPath.item]
        
        let vc = UserInfoVC()
        vc.username = follower.login
        vc.delegate = self
        
        let navToVC = UINavigationController(rootViewController: vc)
        present(navToVC, animated: true)
    }
    
    
}

//MARK: - Search Delegates
extension FollowersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            updateCollectionData(with: followers)
            isStillSearching = false
            return
        }
        
        isStillSearching = true
        searchedFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateCollectionData(with: searchedFollowers)
    }
}


//MARK: - GFItemInfo Delegates
extension FollowersListVC: UserInfoVCDelegate{
    func newFollowersRequested(username: String) {
        self.username = username
        title = username
        followers.removeAll()
        searchedFollowers.removeAll()
        getFollowers(page: 1)
        
        collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
    }
    
}
