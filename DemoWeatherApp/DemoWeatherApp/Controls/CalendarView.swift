//
//  CalendarView.swift
//  DemoWeatherApp
//
//  Created by  User on 11.05.2024.
//

import UIKit

class CalendarView: UICollectionView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout);
        setUp();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        setUp();
    }
    
    //MARK: SETUP
    private func setUp() {
        
    }
    

}
