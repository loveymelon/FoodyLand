//
//  FoodyMapViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/7/24.
//

import UIKit
import CoreLocation
import MapKit
import Toast
import FloatingPanel

enum UnknownError: Error {
    case unowned
}

final class FoodyMapViewController: BaseViewController<FoodyMapView> {
    
    private var locationManager = CLLocationManager()
    let foodyMapViewModel = FoodyMapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkDeviceLocationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        foodyMapViewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func configureNav() {
        let logoImageView = UIImageView()
        
        logoImageView.image = .foodyLogo
        
        self.navigationItem.titleView = logoImageView
    }
    
    override func dataSourceDelegate() {
        self.locationManager.delegate = self
        mainView.searchBar.delegate = self
        mainView.mapView.delegate = self
    }
    
    override func bindData() {
        foodyMapViewModel.outputLocationValue.bind { [weak self] result in
            
            guard let self else { return }
            
            if result.isEmpty {
                mainView.mapView.removeAnnotations(mainView.mapView.annotations)
                return
            } else {
                
                for location in result {
                    
                    let location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                    
                    let marker = FoodyMapMarker(title: "Here", coordinate: location)
                    
                    self.mainView.mapView.addAnnotation(marker)
                    
                }
            }
            
        }
        
        foodyMapViewModel.outputRemoveAll.bind { [weak self] result in
            guard let self else { return }
            
            if result {
                mainView.mapView.removeAnnotations(mainView.mapView.annotations)
                print(foodyMapViewModel.outputRemoveAll.value)
            }
            
        }
    }

}

extension FoodyMapViewController {
    private func checkDeviceLocationAuthorization() {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            
            guard CLLocationManager.locationServicesEnabled() else {
                // 디바이스 자체의 위치 권한이 꺼져있는지 확인 로직
                showSettingAlert(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요")
                return
            }
            
            let authorization: CLAuthorizationStatus
            
            authorization = locationManager.authorizationStatus
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                do {
                    try checkCurrentLocationAuthorization(status: authorization)
                } catch {
                    self.view.makeToast("오류가 발생했습니다.")
                }
            }
        }
        
    }
    
    private func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) throws {
        
        switch status {
        case .notDetermined:
            // 한번도 선택을 안했거나 한번만 허용후 다시 올때
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // 정확도
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            // 거절될때는 미리 준비된 좌표로 보여준다.
            showSettingAlert(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요")
            let coordinate = CLLocationCoordinate2D(latitude: 37.566685, longitude: 126.978400)
            setRegionAndAnnotation(center: coordinate)
            locationManager.stopUpdatingLocation()
        case .restricted:
            // 안심자녀
            showSettingAlert(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요")
        case .authorizedWhenInUse:
            // 사용할 때만
            locationManager.startUpdatingLocation()
        case .authorizedAlways:
            // 항상 허용
            locationManager.startUpdatingLocation()
        default:
            throw UnknownError.unowned
        }
        
    }
    
    private func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1300, longitudinalMeters: 1300)
        
        mainView.mapView.setRegion(region, animated: true)
        
    }
    
}

extension FoodyMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.view.makeToast("비행기 모드를 해제해주세요", position: .bottom)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationLast = locations.last?.coordinate else { 
            manager.stopUpdatingLocation()
            return
        }
        
        mainView.myLocation(latitude: locationLast.latitude, longitude: locationLast.longitude)
    }
    
}

extension FoodyMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil } // 유저의 위치 어노테이션의 모양이 변경되는 것을 방지
    
        var view: MKMarkerAnnotationView
        
        // filemanager 이미지가 없다면 기본 이미지
        
        if let dequeuedView = mapView
            .dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier) as? CustomAnnotationView {
            dequeuedView.annotation = annotation
            return dequeuedView
        } else {
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: CustomAnnotationView.identifier
            ) 
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 0)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
        
    } // custom View
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        
        guard !(annotation is MKUserLocation) else { return } // 유저 어노테이션 터치를 막는 것
        
        let annotationLocation = annotation.coordinate
        
        let location = Location()
        location.latitude = annotationLocation.latitude
        location.longitude = annotationLocation.longitude
        
        foodyMapViewModel.inputTappedAnnoTrigger.value = location
        
        let customDetailVC = CustomDetailViewController()
        
        let detailData = foodyMapViewModel.outputDetailData.value
        
        customDetailVC.customDetailViewModel.inputLocation.value = location
        
        let nav = UINavigationController(rootViewController: customDetailVC)
        
        self.present(nav, animated: true)
    }
    
    
}

extension FoodyMapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 누르면 서치화면이 있는 곳으로 이동
        let vc = SearchViewController()
        
        self.view.endEditing(true)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
