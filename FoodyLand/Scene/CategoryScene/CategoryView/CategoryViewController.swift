//
//  CategoryViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/14/24.
//

import UIKit

enum CellSetion: CaseIterable {
    case plus
    case other
}

protocol CategoryDataDelegate: AnyObject {
    func passCategoryData(res: String)
}

class CategoryViewController: BaseViewController<CategoryView> {
    
    private let categoryViewModel = CategoryViewModel()

    private var dataSource: UICollectionViewDiffableDataSource<CellSetion, String>?
    
    weak var delegate: CategoryDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeCellRegisteration()
        sectionSnapShot(data: [])
        addButtonAction()
        categoryViewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func dataSourceDelegate() {
        mainView.collectionView.delegate = self
    }
    
    override func bindData() {
        categoryViewModel.outputCategoryData.bind { [weak self] result in
            guard let self else { return }
            
            sectionSnapShot(data: result)
        }
    }

}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else {
            return }
        guard let text = cell.categoryLabel.text else { return }
        
        categoryViewModel.selectData = text
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        categoryViewModel.selectData = ""
    }
    
}

extension CategoryViewController {
    private func plusRegistration() -> UICollectionView.CellRegistration<CategoryPlusCollectionViewCell, String> {
        
        return UICollectionView.CellRegistration <CategoryPlusCollectionViewCell, String>{ [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            
            cell.categoryViewModel = categoryViewModel
        }
    }
    
    private func categoryCellRegistration() -> UICollectionView.CellRegistration<CategoryCollectionViewCell, String> {
        
        UICollectionView.CellRegistration <CategoryCollectionViewCell, String>{ [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            
            cell.categoryLabel.text = itemIdentifier
        }
    }
    
    private func makeCellRegisteration() {
        
        let plusRegistration = plusRegistration()
        let categoryRegistration = categoryCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let section = CellSetion.allCases[indexPath.section]
            
            switch section {
            case .plus:
                let cell = collectionView.dequeueConfiguredReusableCell(using: plusRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .other:
                let cell = collectionView.dequeueConfiguredReusableCell(using: categoryRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        })
        
    }
    
    private func sectionSnapShot(data: [String]) {
        
        var snapshot = NSDiffableDataSourceSectionSnapshot<String>()
        
        snapshot.append([""])
        dataSource?.apply(snapshot, to: .plus)
        
        var subSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
        
        subSnapshot.append(data)
        dataSource?.apply(subSnapshot, to: .other)
        
    }
    
    private func addButtonAction() {
        mainView.cancelButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            
            dismiss(animated: true)
            
        }), for: .touchUpInside)
        
        mainView.checkButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            guard !categoryViewModel.selectData.isEmpty else { return }
            
            delegate?.passCategoryData(res: categoryViewModel.selectData)
            
            dismiss(animated: true)
            
        }), for: .touchUpInside)
        
        mainView.deleteButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            guard !categoryViewModel.selectData.isEmpty else { return }
            
            categoryViewModel.inputDeleteTrigger.value = ()
            
        }), for: .touchUpInside)
    }
    
}

