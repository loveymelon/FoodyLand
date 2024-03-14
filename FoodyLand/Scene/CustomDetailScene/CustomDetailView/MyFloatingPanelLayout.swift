//
//  MyFloatingPanelLayout.swift
//  FoodyLand
//
//  Created by 김진수 on 3/12/24.
//

import Foundation
import FloatingPanel

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
    ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}
