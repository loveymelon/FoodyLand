//
//  CategoryCollectionViewCell.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import UIKit
import Then
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    let categoryImageView = UIImageView().then {
        $0.image = UIImage(systemName: "circle")
    }
    
    let categoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectCell()
            } else {
                deSelectCell()
            }
        }
    }
    
}

extension CategoryCollectionViewCell: ConfigureUIProtocol {
    func configureUI() {
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(categoryImageView)
        contentView.addSubview(categoryLabel)
    }
    
    func configureLayout() {
        categoryImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).inset(10)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.height.centerY.equalTo(categoryImageView)
            make.leading.equalTo(categoryImageView.snp.trailing).offset(10)
        }
    }
}

extension CategoryCollectionViewCell {
    func selectCell() {
        self.categoryImageView.image = UIImage(systemName: "circle.inset.filled")
        print(self.isSelected)
    }
    
    func deSelectCell() {
        self.categoryImageView.image = UIImage(systemName: "circle")
        print(self.isSelected)
    }
}
