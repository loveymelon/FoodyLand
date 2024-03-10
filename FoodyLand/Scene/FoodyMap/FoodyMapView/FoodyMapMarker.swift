//
//  FoodyMapMarker.swift
//  FoodyLand
//
//  Created by 김진수 on 3/8/24.
//

import MapKit

final class FoodyMapMarker: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}
