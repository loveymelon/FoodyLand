//
//  CalendarViewController.swift
//  FoodyLand
//
//  Created by 김진수 on 3/12/24.
//

import UIKit
import FSCalendar

protocol CalendarDataDelegate: AnyObject {
    func selectedDate(date: Date)
}

class CalendarViewController: BaseViewController<CalendarView> {
    
    weak var delegate: CalendarDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func dataSourceDelegate() {
        mainView.calendarView.delegate = self
    }
    
    deinit {
        print("Calendar Deinit")
    }
    
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        delegate?.selectedDate(date: date)
        
        dismiss(animated: true)
    }
}
