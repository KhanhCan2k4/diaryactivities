//
//  CalendarCollectionViewCell.swift
//  DemoWeatherApp
//
//  Created by  User on 11.05.2024.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnDate: UIButton!
    
    public var date = Date();
    
    
    @IBAction func chooseDate(_ sender: UIButton) {
        btnDate.isSelected = true;
        
        print("go to this date \(self.date.formatted(date: .long, time: .standard))");
        
        btnDate.isSelected = false;
    }
}
