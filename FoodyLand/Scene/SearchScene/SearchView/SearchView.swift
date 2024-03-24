//
//  SearchView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/10/24.
//

import UIKit
import SnapKit
import Then

final class SearchView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let noDataView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .customYellow
    }
    
    let noDataLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .boldSystemFont(ofSize: 30)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
        self.addSubview(noDataView)
        self.noDataView.addSubview(noDataLabel)
    }
    
    override func configureLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide.snp.edges)
        }
        self.noDataView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.noDataLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(noDataView)
        }
    }
    
}

extension SearchView {
    private static func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        configuration.backgroundColor = .customYellow
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
}
