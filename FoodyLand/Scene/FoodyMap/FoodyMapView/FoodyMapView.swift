//
//  FoodyMapView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/7/24.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation
import Then

final class FoodyMapView: BaseView {
    
    lazy var mapView = MKMapView(frame: .zero).then {
        let location = CLLocationCoordinate2D(latitude: 37.654165, longitude: 127.049696)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // 지역 범위의 폭과 너비
        let region = MKCoordinateRegion(center: location, span: span)
//        let chang = FoodyMapMarker(title: "ddd", coordinate: location)
        
//        $0.addAnnotation(chang)
        $0.mapType = .standard // 다시 실행했을때 오류 방지
        $0.showsUserLocation = true // 지도에 내 위치 표시
        $0.setUserTrackingMode(.follow, animated: true) // 현재 내 위치 기준으로 지도 움직이기
        $0.setRegion(region, animated: true)
        $0.backgroundColor = .red
        $0.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(recognizeLongPress))
        
        // Added UIGestureRecognizer to MapView.
        $0.addGestureRecognizer(myLongPress)
    }
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "맛집 검색(상호명을 입력해주세요~!!)"
        $0.setTextFieldBackground(color: .white)
        
        $0.searchTextField.layer.shadowColor = UIColor.black.cgColor
        $0.searchTextField.layer.shadowOpacity = 0.25
        $0.searchTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.searchTextField.layer.shadowRadius = 5
    }
    
//    var longPressClosure: ((CLLocationCoordinate2D) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.customYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(mapView)
        self.mapView.addSubview(searchBar)
    }
    
    override func configureLayout() {
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide.snp.edges)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.mapView).inset(10)
        }
        
    }
    
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .ended {
            return
        }
        
        let annotations = mapView.annotations
        
        mapView.removeAnnotations(annotations)
        
        if sender.state == .began {
            let location = sender.location(in: mapView) // 맵 뷰의 포인트를 얻고
            
            let locationOnMap = mapView.convert(location, toCoordinateFrom: mapView) // 그 포인트를 맵 뷰 기준으로 위도 경도를 얻음
            
//            longPressClosure?(locationOnMap)
            let chang = FoodyMapMarker(title: "ghgh", coordinate: locationOnMap)
            self.mapView.addAnnotation(chang)
            print(#function)
            
        }
        
    }
}
