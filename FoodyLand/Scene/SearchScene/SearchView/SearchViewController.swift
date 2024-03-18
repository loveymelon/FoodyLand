//
//  SearchViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/10/24.
//

import UIKit

enum Section: Hashable, CaseIterable {
    case search
}

final class SearchViewController: BaseViewController<SearchView> {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchViewModel = SearchViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Address>?
    
    // 값이 넘어올때마다 append 시켜야됨 그럼 배열로 받아와야되지 않을까?
    // search의 값이 변경 된다면 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        configureDataSource()
        snapShot(value: [])
    }

    override func configureNav() {
        super.configureNav()
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "맛집 검색"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.navigationController?.navigationBar.backgroundColor = .customYellow
    }
    
    override func dataSourceDelegate() {
        searchController.searchBar.delegate = self
        mainView.collectionView.prefetchDataSource = self
        mainView.collectionView.delegate = self
    }
    
    override func bindData() {
        searchViewModel.outputText.bind { [weak self] result in
            guard let self = self else { return }
            
            snapShot(value: result)
        }
    }
    
}

extension SearchViewController {
    private func setupSearchController() {
        searchController.searchBar.placeholder = "맛집 검색(상호명을 입력해주세요~!!)"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, Address>(handler: { cell, indexPath, itemIdentifier in
            cell.locationMark.image = UIImage(systemName: "star")
            cell.titleLabel.text = itemIdentifier.placeName
            cell.addLabel.text = itemIdentifier.roadAddress
        })
        
        dataSource = UICollectionViewDiffableDataSource<Section, Address>(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func snapShot(value: [Address]) {
        // enter를 칠때마다 snapShot을 새로만들고 Diffable에 적용해야된다.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Address>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(value)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // 소켓 통신은 추후 업데이트
        searchViewModel.inputSearchText.value = searchBar.text
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CustomDetailViewController()
        
        guard let data = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        vc.customDetailViewModel.inputSearchData = data
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let data = searchViewModel.outputText.value
        let page = searchViewModel.outputData.value
        
        for item in indexPaths {
            if data.count - 3 <= item.item && !page.isEnd {
                searchViewModel.inputPage.value = searchViewModel.inputPage.value + 1
            }
        }
    }
    
}
