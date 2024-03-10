//
//  SearchView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/10/24.
//

import UIKit
import SnapKit
import Then

class SearchView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide.snp.edges)
        }
    }
    
}

extension SearchView {
    static func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        configuration.backgroundColor = .customYellow
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
}
