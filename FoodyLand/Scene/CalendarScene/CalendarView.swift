//
//  CalendarView.swift
//  FoodyLand
//
//  Created by 김진수 on 3/12/24.
//

import UIKit
import FSCalendar
import SnapKit
import Then

class CalendarView: BaseView {
    
    let calendarView = FSCalendar(frame: .zero).then {
        $0.scope = .month
        $0.locale = Locale(identifier: "ko_KR")
        $0.scrollEnabled = true
        $0.scrollDirection = .horizontal
        $0.appearance.headerTitleAlignment = .left
        $0.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        self.addSubview(calendarView)
    }
    
    override func configureLayout() {
        calendarView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    
}
