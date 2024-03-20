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
    
    override func dataSourceDelegate() {
        self.locationManager.delegate = self
        mainView.searchBar.delegate = self
        mainView.mapView.delegate = self
    }
    
    override func bindData() {
        foodyMapViewModel.outputLocationValue.bind { result in
            
            if result.isEmpty {
                return
            }
            
            print(result)
            
            let location = CLLocationCoordinate2D(latitude: result[1], longitude: result[0])
            
            print(result)
            let chang = FoodyMapMarker(title: "ddd", coordinate: location)
            
            self.mainView.mapView.addAnnotation(chang)
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
        print("location", locations[0].coordinate)
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
            view.calloutOffset = CGPoint(x: -10, y: 10)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
        
    } // custom View
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let annotation = MKPointAnnotation()
//        print(mapView.region.center)
//        
//        annotation.title = "Here"
//        annotation.coordinate = mapView.region.center
//        
//        self.mainView.mapView.addAnnotation(annotation)
//    }
    
}

extension FoodyMapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 누르면 서치화면이 있는 곳으로 이동
        print(#function)
        
        let vc = SearchViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
