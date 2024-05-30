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
    
    public var homeController:HomeController?;
    
    
    @IBAction func chooseDate(_ sender: UIButton) {
        btnDate.isSelected = true;
        
        self.homeController!.toGoActitvitiesView(date: self.date);
        
        btnDate.isSelected = false;
    }
}
