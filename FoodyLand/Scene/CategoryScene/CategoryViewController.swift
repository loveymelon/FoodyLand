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

    private var dataSource: UICollectionViewDiffableDataSource<CellSetion, CategoryData>?
    
    weak var delegate: CategoryDataDelegate?
    
    var res = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeCellRegisteration()
        sectionSnapShot()
        addButtonAction()
    }
    
    override func dataSourceDelegate() {
        mainView.collectionView.delegate = self
    }
    
    override func bindData() {
        categoryViewModel.arr2.bind { [weak self] _ in
            guard let self else { return }
            
            sectionSnapShot()
        }
    }

}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else {
            print("aaa")
            return }
        
        res = cell.categoryLabel.text!
//        if indexPath.section == 1 {
//            let cell =
//        }
    }
}

extension CategoryViewController {
    private func plusRegistration() -> UICollectionView.CellRegistration<CategoryPlusCollectionViewCell, CategoryData> {
        
        return UICollectionView.CellRegistration <CategoryPlusCollectionViewCell, CategoryData>{ [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            
            cell.categoryViewModel = categoryViewModel
        }
    }
    
    private func categoryCellRegistration() -> UICollectionView.CellRegistration<CategoryCollectionViewCell, CategoryData> {
        
        UICollectionView.CellRegistration <CategoryCollectionViewCell, CategoryData>{ [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            
            cell.categoryLabel.text = itemIdentifier.text
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
    
    private func sectionSnapShot() {
        
        var snapshot = NSDiffableDataSourceSectionSnapshot<CategoryData>()
        
        snapshot.append([CategoryData(text: "")])
        dataSource?.apply(snapshot, to: .plus)
        
        var subSnapshot = NSDiffableDataSourceSectionSnapshot<CategoryData>()
        
        subSnapshot.append(categoryViewModel.arr2.value)
        dataSource?.apply(subSnapshot, to: .other)
        
    }
    
    private func addButtonAction() {
        mainView.cancelButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            
            dismiss(animated: true)
            
        }), for: .touchUpInside)
        
        mainView.checkButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            guard !res.isEmpty else { return }
            
            delegate?.passCategoryData(res: res)
            
            dismiss(animated: true)
            
        }), for: .touchUpInside)
    }
    
}
