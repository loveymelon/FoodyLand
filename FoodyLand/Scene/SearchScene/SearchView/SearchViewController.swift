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
    
    deinit {
        print("search deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "맛집 검색"
    }

    override func configureNav() {
        super.configureNav()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.backgroundColor = .customYellow
    }
    
    override func dataSourceDelegate() {
        searchController.searchBar.delegate = self
        mainView.collectionView.prefetchDataSource = self
        mainView.collectionView.delegate = self
    }
    
    override func bindData() {
        searchViewModel.outputText.bind { [weak self] result in
            guard let self = self else { return }
            
            mainView.noDataView.isHidden = true
            mainView.collectionView.isHidden = false
            
            snapShot(value: result)
        }
        
        searchViewModel.outputError.bind { [weak self] result in
            guard let self else { return }
            guard let error = result else { return }
            
            if error == .invalidStatusCode(200) {
                guard let text = searchController.searchBar.text else { return }
                
                mainView.noDataView.isHidden = false
                mainView.collectionView.isHidden = true
                mainView.noDataLabel.text = "\(text)의 검색 결과가 없습니다."
            }
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
            cell.locationMark.image = .restaurant
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
        
        if !value.isEmpty {
            mainView.collectionView.isScrollEnabled = true
        } else {
            mainView.collectionView.isScrollEnabled = false
        }
        
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
        
        searchViewModel.inputSelectedData.value = data
        
        vc.customDetailViewModel.outputDetailData.value = searchViewModel.outputUserDiary.value
        vc.customDetailViewModel.inputLocation.value.latitude = searchViewModel.outputLocation.value.latitude
        vc.customDetailViewModel.inputLocation.value.longitude = searchViewModel.outputLocation.value.longitude
        
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
