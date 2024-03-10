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
    
    let backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    let imageView = UIImageView()
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let annotation = annotation as? FoodyMapMarker else { return }
        
        //            guard let imageName = annotation.imageName,
        //                  let image = UIImage(named: imageName) else { return }
        
        imageView.image = UIImage(named: "noun-fork-1550323")
        
        setNeedsLayout()
        
    }
    
}

extension CustomAnnotationView: ConfigureUIProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        self.addSubview(backView)
        self.backView.addSubview(imageView)
    }
    
    func configureLayout() {
        self.backView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        self.imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.edges.equalToSuperview().inset(5)
        }
    }
}
