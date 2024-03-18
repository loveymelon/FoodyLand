//
//  CustomDetailViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/11/24.
//

import UIKit
import FloatingPanel
import Then
import PhotosUI
import Toast
import os

// 서치 화면에 아무것도 없을때 화면 구성하고 cellConfigure따로 빼기 오늘은 공수산정 꼭 정하자

// 이미지의 수가 3개일 때, phpicker로 가는 버튼을 막고 항상 삭제를 할지 추가를 할지 물어본다.
// 우선 이미지를 눌렀을때 알렛으로 나오게하자

final class CustomDetailViewController: BaseViewController<CustomDetailView> {
    
    lazy var fpVC = FloatingPanelController().then {
        let calendarVC = CalendarViewController() // 이렇게 되면 CustomDetailViewController이 메모리에 올라올때 같이 올라온다 이걸 어떻게 수정할지 고민해보자
        calendarVC.delegate = self
        $0.set(contentViewController: calendarVC)
        $0.isRemovalInteractionEnabled = true
        $0.layout = MyFloatingPanelLayout()
    }
    
    let customDetailViewModel = CustomDetailViewModel()
    var userImages: [UIImage] = [] {
        didSet {
            mainView.marketDetailView.pageControl.numberOfPages = userImages.count
            
            mainView.marketDetailView.marketImageView.image = userImages.count != 0 ? userImages[mainView.marketDetailView.pageControl.currentPage] : .basic
            
            print(userImages)
            
        }
    } // viewModel에 보내서 갯수가 마지막인지 파악후 bool값을 보낸다.
    
    @objc func tappedImageView() {

        showImageAlert(bool: true) { [weak self] in
            guard let self else { return }
            
            if userImages.count != 0 {
                userImages.remove(at: mainView.marketDetailView.pageControl.currentPage)
            }
            
        } completionHandler: { [weak self] in
            guard let self else { return }
            
            customDetailViewModel.inputImageCount.value = userImages.count
            
            if customDetailViewModel.outputImageCountRes.value {
                self.view.makeToast("사진은 최대 3개까지입니다. 삭제해주세요!" , duration: 1, position: .center)
                return
            }
            openPhotoLibrary()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewAddAction()
        photoAuth()
        imageAddGesture()
        
        customDetailViewModel.inputViewDidLoadTrigger.value = ()
        
    }
    
    override func bindData() {
        customDetailViewModel.outputDetailData.bind { [weak self] result in
            guard let self = self else { return }
            customDetailViewModel.inputImageCount.value = userImages.count
            
            mainView.marketDetailView.marketTitleLabel.text = result.marketName
            mainView.marketDetailView.marketURLLabel.text = result.url
            mainView.marketDetailView.marketAddLabel.text = result.address
        }
        
        customDetailViewModel.outputCalendarData.bind { [weak self] result in
            guard let self = self else { return }
            guard !result.isEmpty else { return }
            mainView.calendarLabel.text = result
        }
    }
    
    override func dataSourceDelegate() {
        mainView.marketDetailView.scrollView.delegate = self
        
        fpVC.delegate = self
    }
    
}

extension CustomDetailViewController {
    private func mainViewAddAction() {
        mainView.calendarButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            
            fpVC.addPanel(toParent: self)
        }), for: .touchUpInside)
        
        mainView.saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
//            guard let rootVC = self.navigationController?.viewControllers[0] as? FoodyMapViewController else { return }

            // viewModel - star, category, calendar, image, memo
            
            mainView.marketDetailView.marketImageView.image
            
            customDetailViewModel.inputDetailData.value = DetailData(memo: mainView.memoTextView.text, star: mainView.starView.rating, calender: mainView.calendarLabel.text ?? "", category: mainView.categoryLabel.text ?? "")
            
//            rootVC.foodyMapViewModel.inputLocationValue.value = customDetailViewModel.inputSearchData
//            
//            self.navigationController?.popToRootViewController(animated: true)
        }), for: .touchUpInside)
            
        
        mainView.categoryButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            
            let categoryVC = CategoryViewController()
            
            categoryVC.delegate = self
            categoryVC.modalPresentationStyle = .automatic
            
            mainView.categoryLabel.text = ""
            
            self.present(categoryVC, animated: true)
            
        }), for: .touchUpInside)
        
        mainView.marketDetailView.pageControl.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            
            mainView.marketDetailView.marketImageView.image = userImages[mainView.marketDetailView.pageControl.currentPage]
        }), for: .valueChanged)
    }
    
    private func imageAddGesture() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImageView))
        
        mainView.marketDetailView.marketImageView.addGestureRecognizer(imageTapGesture)
    }
    
    private func photoAuth() {
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { [weak self] authorizationStatus in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch authorizationStatus {
                case .denied, .notDetermined, .limited:
                    self.showSettingAlert(title: "사진 라이브러리 권한 필요", message: "사진을 선택하려면 사진 라이브러리 권한이 필요합니다. 설정에서 권한을 변경할 수 있습니다.")
                case .authorized, .restricted:
                    break
                default:
                    self.showSettingAlert(title: "사진 라이브러리 권한 필요", message: "사진을 선택하려면 사진 라이브러리 권한이 필요합니다. 설정에서 권한을 변경할 수 있습니다.")
                }
            }
        }
    }
    
    private func openPhotoLibrary() {
        print(#function)
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .restricted {
            var configuration = PHPickerConfiguration()
            
            // 사진을 누르면 바로 내려감....
            configuration.selectionLimit = customDetailViewModel.outputImageCount.value
            configuration.filter = .any(of: [.images])
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            self.present(picker, animated: true)
        } else {
            DispatchQueue.main.async {
                self.showSettingAlert(title: "사진 라이브러리 권한 필요", message: "사진을 선택하려면 사진 라이브러리 권한이 필요합니다. 설정에서 권한을 변경할 수 있습니다.")
            }
            
        }
    }
    
}

extension CustomDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, shouldRemoveAt location: CGPoint, with velocity: CGVector) -> Bool {
//        fpc.removePanelFromParent(animated: true)
        return true
    }
}

extension CustomDetailViewController: CalendarDataDelegate {
    func selectedDate(date: Date) {
        print(date)
        customDetailViewModel.inputCalendarData.value = date
    }
}

extension CustomDetailViewController: CategoryDataDelegate {
    func passCategoryData(res: String, index: Int?) {
        mainView.categoryLabel.text = res
        customDetailViewModel.selectedIndex = index
    }
}

// 🎆 유저가 선택을 완료했거나 취소 버튼으로 닫았을 때 알려주는 delegate
extension CustomDetailViewController: PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        var selectedImages: [UIImage] = []
        
        let group = DispatchGroup()
        
        for result in results where result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _ ) in
                guard let self = self else { return }
                
                guard let image = image as? UIImage else { return }
                selectedImages.append(image)
                
                guard selectedImages.count == results.count else { return }
                
                customDetailViewModel.inputImageData.value = selectedImages.count
                
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    userImages.append(contentsOf: selectedImages)
                    
                    mainView.marketDetailView.marketImageView.image = selectedImages[0]
                    picker.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
}


extension CustomDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = mainView.marketDetailView.scrollView.contentOffset.x / mainView.marketDetailView.scrollView.frame.size.width
        
    }
}
