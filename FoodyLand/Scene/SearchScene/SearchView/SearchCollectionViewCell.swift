//
//  SearchCollectionViewCell.swift
//  FoodyLand
//
//  Created by 김진수 on 3/10/24.
//

import UIKit
import Then
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    let locationMark = UIImageView()
    
    let titleLabel = UILabel()
    
    let addLabel = UILabel()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.spacing = 5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchCollectionViewCell: ConfigureUIProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(locationMark)
        
        [titleLabel, addLabel].forEach { item in
            self.stackView.addArrangedSubview(item)
        }
        
        contentView.addSubview(stackView)
    }
    
    func configureLayout() {
        
        locationMark.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).inset(10)
            make.centerY.equalTo(self.stackView.snp.centerY)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        addLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.contentView).inset(10)
            make.leading.equalTo(self.locationMark.snp.trailing).offset(10)
        }
        
    }
}
