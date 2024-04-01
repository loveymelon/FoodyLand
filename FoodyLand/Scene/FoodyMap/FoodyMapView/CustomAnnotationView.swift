//
//  CustomAnnotationView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/8/24.
//

import MapKit
import SnapKit
import Then

final class CustomAnnotationView: MKAnnotationView {
    
    let imageView = UIImageView()
    var ddddd: String = ""
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        imageView.image = nil
//    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        // 현재 위치 표시(점)도 일종에 어노테이션이기 때문에, 이 처리를 안하게 되면, 유저 위치 어노테이션도 변경 된다.
        guard let annotation = annotation as? FoodyMapMarker else { return }
        
        //            guard let imageName = annotation.imageName,
        //                  let image = UIImage(named: imageName) else { return }
        
        imageView.image = .restaurant
        
        setNeedsLayout()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        centerOffset = CGPoint(x: 0, y: -10)
        bounds.size = CGSize(width: 50, height: 50)
    }
    
}

extension CustomAnnotationView: ConfigureUIProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        self.addSubview(imageView)
    }
    
    func configureLayout() {
        
        self.imageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
    }
}
