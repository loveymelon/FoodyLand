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
import IQKeyboardManagerSwift

// 삭제후 추가 저장이 안됨
// 이전 데이터에 그냥 추가도 안된다.

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
            customDetailViewModel.inputUserImageCount.value = userImages.count
            
            mainView.marketDetailView.marketImageView.image = !userImages.isEmpty /*customDetailViewModel.outputImageEmptyBool.value*/ ? userImages[mainView.marketDetailView.pageControl.currentPage] : .basic
        }
    }
    
    @objc func tappedImageView() {

        showImageAlert(bool: true) { [weak self] in
            guard let self else { return }
            
            if userImages.count != 0 {
                
                customDetailViewModel.inputDeleteImageDatas.value = mainView.marketDetailView.pageControl.currentPage
                
                userImages.remove(at: mainView.marketDetailView.pageControl.currentPage)
            }
            
        } completionHandler: { [weak self] in
            guard let self else { return }
            
            customDetailViewModel.inputUserImageCount.value = userImages.count
            
            if customDetailViewModel.outputImageOverBool.value {
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
            print(#function)
            
            customDetailViewModel.inputUserImageCount.value = result.userImages.count
            
            if customDetailViewModel.outputImageEmptyBool.value {
                for item in result.userImages {
                    
                    let res = loadImageToDocument(imageName: item.id.stringValue, fileName: result.id.stringValue)
                    
                    switch res {
                    case .success(let success):
                        userImages.append(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            } else {
                userImages = []
            }
            
            mainView.marketDetailView.marketTitleLabel.text = result.marketName
            mainView.marketDetailView.marketURLLabel.text = result.url
            mainView.marketDetailView.marketAddLabel.text = result.address
            mainView.calendarLabel.text = result.date.toString()
            mainView.memoTextView.text = result.memo
            mainView.categoryLabel.text = result.category?.categoryName
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
            guard let rootVC = self.navigationController?.viewControllers[0] as? FoodyMapViewController else {
                saveDatas()
                dismiss(animated: true)
                return }
            
            saveDatas()
            
            rootVC.foodyMapViewModel.inputLocationValue.value = customDetailViewModel.inputLocation.value
            self.navigationController?.popToRootViewController(animated: true)
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
    
    private func saveDatas() {
        let images = userImages // 지속적으로 realm을 업데이트하고 fetch를 할때 bind가 이뤄져서 값이 달라지므로 저장해서 이 값을 쓰는 것이다.
        // 굳이 Realm을 업데이트하고 바로 fetch를 할 필요가 없다 인스턴스만 생성해서 그 id값으로 파일 매니저를 다루고 마지막에 업데이트 시키면 된다. 이건 나중에 리팩토링할때 반영하자
        
        customDetailViewModel.detailData = DetailData(memo: mainView.memoTextView.text, star: mainView.starView.rating, calender: mainView.calendarLabel.text ?? "", category: mainView.categoryLabel.text ?? "")
        
        customDetailViewModel.inputSaveButtonTrigger.value = ()
        
        if customDetailViewModel.outputDetailData.value.userImages.isEmpty {
            
            if userImages.isEmpty {
                return
            }
            
            let detailData = customDetailViewModel.outputDetailData.value
            
            customDetailViewModel.inputSaveImageCount.value = userImages.count // 이미지 갯수만큼 생성후
            
            for (index, item) in detailData.userImages.enumerated() {
                
                let res = saveImageToDocument(image: userImages[index], fileName: detailData.id.stringValue, imageName: item.id.stringValue)
                
                switch res {
                case .success(_):
                    print("success")
                case .failure(let failure):
                    print(failure)
                }
                
            }
            
        } else {
            
            if !customDetailViewModel.outputImageDeleteData.value.isEmpty /* 삭제할 데이터가 있을때 로직 들어감*/ {
                let bool = customDetailViewModel.outputImageExistBool.value// imageRemoveId의 개수 == 3 이라면 true
                let fileName = customDetailViewModel.outputDetailData.value.id.stringValue
                let removeIndex = customDetailViewModel.outputImageDeleteData.value
                
                print(#function)
                
                for index in removeIndex {
                    
                    let res = removeImageFromDocument(imageName: customDetailViewModel.outputDetailData.value.userImages[index].id.stringValue, fileName: fileName, noData: bool)
                    
                    switch res {
                    case .success(_):
                        print("success")
                    case .failure(let failure):
                        print(failure)
                    }
                } // File 이미지 삭제
                
                customDetailViewModel.inputDeleteImageTrigger.value = () // 조건 들어갈 시 Realm 내부의 이미지 삭제 및 그 만큼 이미지를 생성해준다.
                
                // 생성한 이미지를 파일에 저장하는 과정
                // 이미지를 삭제만 했는지의 여부를 파악
                if !customDetailViewModel.outputImageNoCreate.value {
                    
                    for index in (images.count - customDetailViewModel.outputImageCreateCount.value)...images.count - 1 {
                        
                        let res = saveImageToDocument(image: images[index], fileName: customDetailViewModel.outputDetailData.value.id.stringValue, imageName: customDetailViewModel.outputDetailData.value.userImages[index].id.stringValue) // realm 데이터를 통해서 파일에 새로운 데이터 저장
                        
                        switch res {
                        case .success(_):
                            print("success")
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                    
                }
                
            } else {
                
                let detailData = customDetailViewModel.outputDetailData.value
                let addData = images.count - customDetailViewModel.outputDetailData.value.userImages.count
                
                if addData == 0 {
                    return
                }
                
                customDetailViewModel.inputSaveImageCount.value = addData
                
                // 삭제할 데이터 없이 추가만 한다면?
                for index in (images.count - addData)...images.count - 1 {
                    
                    let res = saveImageToDocument(image: userImages[index], fileName: detailData.id.stringValue, imageName: detailData.userImages[index].id.stringValue)
                    
                    switch res {
                    case .success(_):
                        print("success")
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
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
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    userImages.append(contentsOf: selectedImages)
                    
//                    mainView.marketDetailView.marketImageView.image = selectedImages[0]
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
