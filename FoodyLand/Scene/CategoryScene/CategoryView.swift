//
//  CategoryView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import UIKit
import SnapKit
import Then

class CategoryView: BaseView {

    let backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    let categoryLabel = UILabel().then {
        $0.text = "카테고리"
    }
    
    let checkButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.title = "저장"
        let button = UIButton(configuration: buttonConfig)
        return button
    }()
    
    let cancelButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.title = "취소"
        let button = UIButton(configuration: buttonConfig)
        return button
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.allowsMultipleSelection = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(backView)
        self.addSubview(categoryLabel)
        self.addSubview(checkButton)
        self.addSubview(cancelButton)
        self.backView.addSubview(collectionView)
    }
    
    override func configureLayout() {
        self.backView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(20)
            make.height.equalTo(self.backView.snp.width)
            make.centerX.centerY.equalTo(self)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(self.backView).inset(10)
            make.height.equalTo(24)
        }
        
        checkButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.backView).inset(10)
            make.height.equalTo(24)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.checkButton.snp.leading).offset(5)
            make.bottom.equalTo(checkButton.snp.bottom)
            make.height.equalTo(24)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.backView)
            make.top.equalTo(self.categoryLabel.snp.bottom)
            make.bottom.equalTo(self.checkButton.snp.top)
        }
    }
    
}

extension CategoryView {
    private static func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            
//            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
//            
//            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//            
//            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
//            
//            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            
            let section = CellSetion.allCases[sectionIndex]
            
            let layoutSection: NSCollectionLayoutSection
            
            //        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            //
            //        configuration.backgroundColor = .white
            //        configuration.showsSeparators = false
            //
            //        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
            //
            //        return layout
            // Cell
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
            // Section
            layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 5
            
//            if sectionIndex == 0 {
//                layoutSection.boundarySupplementaryItems = [header]
//            } else {
//                layoutSection.boundarySupplementaryItems = [footer]
//            }
            return layoutSection
        }
        
        return layout

    }
}
