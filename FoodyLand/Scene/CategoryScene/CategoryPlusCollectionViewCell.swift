//
//  CategoryPlusCollectionViewCell.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import UIKit
import Then
import SnapKit

class CategoryPlusCollectionViewCell: UICollectionViewCell {
    
    var categoryViewModel: CategoryViewModel?
    
    let plusImageView = UIImageView().then {
        $0.image = UIImage(systemName: "plus")
    }
    
    let plusLabel = UILabel().then {
        $0.text = "새 카테고리"
    }
    
    let plusTextField = UITextField().then {
        $0.isHidden = true
        $0.rightViewMode = .always
        $0.addLeftPadding()
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(#function)
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

extension CategoryPlusCollectionViewCell: ConfigureUIProtocol {
    func configureUI() {
        let buttons = TextFieldButtonsView()
        
        buttons.cancelButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            
            self.isSelected = false
            deSelectCell()
            
        }), for: .touchUpInside)
        
        buttons.checkButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            guard let text = plusTextField.text else { return }
            
            categoryViewModel?.arr2.value.insert(CategoryData(text: text), at: 0)
            
            self.isSelected = false
            deSelectCell()
        }), for: .touchUpInside)
        
        buttons.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(24)
        }
        
        plusTextField.rightView = buttons
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(plusImageView)
        contentView.addSubview(plusLabel)
        contentView.addSubview(plusTextField)
    }
    
    func configureLayout() {
        plusImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).inset(10)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.height.centerY.equalTo(plusImageView)
            make.leading.equalTo(plusImageView.snp.trailing).offset(10)
        }
        
        plusTextField.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
    }
}

extension CategoryPlusCollectionViewCell {
    func selectCell() {
        self.plusImageView.isHidden = true
        self.plusLabel.isHidden = true
        self.plusTextField.isHidden = false
    }
    
    func deSelectCell() {
        self.plusTextField.text = ""
        
        self.plusTextField.isHidden = true
        self.plusImageView.isHidden = false
        self.plusLabel.isHidden = false
    }
}
