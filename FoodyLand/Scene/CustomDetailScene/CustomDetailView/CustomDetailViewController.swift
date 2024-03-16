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

// 서치 화면에 아무것도 없을때 화면 구성하고 cellConfigure따로 빼기 오늘은 공수산정 꼭 정하자

final class CustomDetailViewController: BaseViewController<CustomDetailView> {
    
    lazy var fpVC = FloatingPanelController().then {
        let calendarVC = CalendarViewController() // 이렇게 되면 CustomDetailViewController이 메모리에 올라올때 같이 올라온다 이걸 어떻게 수정할지 고민해보자
        calendarVC.delegate = self
        $0.set(contentViewController: calendarVC)
        $0.isRemovalInteractionEnabled = true
        $0.layout = MyFloatingPanelLayout()
    }
    
    let customDetailViewModel = CustomDetailViewModel()
    
    @objc func tappedImageView() {
        openPhotoLibrary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAddAction()
        photoAuth()
        imageAddGesture()
    }
    
    override func bindData() {
        customDetailViewModel.inoutputDetailData.bind { [weak self] result in
            guard let self = self else { return }
            
            mainView.marketDetailView.marketTitleLabel.text = result.placeName
            mainView.marketDetailView.marketURLLabel.text = result.placeURL
            mainView.marketDetailView.marketAddLabel.text = result.roadAddress
        }
        
        customDetailViewModel.outputCalendarData.bind { [weak self] result in
            guard let self = self else { return }
            guard !result.isEmpty else { return }
            mainView.calendarLabel.text = result
        }
    }
    
    override func dataSourceDelegate() {
        fpVC.delegate = self
    }
    
}

extension CustomDetailViewController {
    private func buttonAddAction() {
        mainView.calendarButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            
            fpVC.addPanel(toParent: self)
        }), for: .touchUpInside)
        
        mainView.saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            guard let rootVC = self.navigationController?.viewControllers[0] as? FoodyMapViewController else { return }
            
            rootVC.foodyMapViewModel.inputLocationValue.value = customDetailViewModel.inoutputDetailData.value
            
            self.navigationController?.popToRootViewController(animated: true)
        }), for: .touchUpInside)
        
        mainView.categoryButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            
            let categoryVC = CategoryViewController()
            
            categoryVC.delegate = self
            categoryVC.modalPresentationStyle = .automatic
            
            self.present(categoryVC, animated: true)
            
        }), for: .touchUpInside)
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
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .restricted {
            var configuration = PHPickerConfiguration()
            
            configuration.selectionLimit = 3
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
    func passCategoryData(res: String) {
        mainView.categoryLabel.text = res
    }
}

// 🎆 유저가 선택을 완료했거나 취소 버튼으로 닫았을 때 알려주는 delegate
extension CustomDetailViewController: PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        var selectedImages: [UIImage] = []
        
        let group = DispatchGroup()
        
        for result in results where result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _ ) in
                guard let self = self else { return }
                
                guard let image = image as? UIImage else { return }
                selectedImages.append(image)
                
                group.leave()
                
                guard selectedImages.count == results.count else { return }
                group.notify(queue: .main) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        mainView.marketDetailView.marketImageView.image = selectedImages[0]
                        picker.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        
        
    }
}
