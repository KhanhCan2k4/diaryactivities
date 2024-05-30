//
//  HomeController.swift
//  DemoWeatherApp
//
//  Created by MAC on 13/5/24.
//

import UIKit

class HomeController: UIViewController,
  UICollectionViewDelegate,
  UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell {
            
            cell.btnDate.setTitle("\(calendar.component(.day, from: list[indexPath.row]))", for: .normal);
            
            cell.btnDate.tintColor = .blue;
            cell.btnDate.isHidden = false;
            
            var frame = cell.btnDate.frame;
            frame.size.width = 50;
            frame.size.height = 50;
            cell.btnDate.frame = frame;
            
            cell.btnDate.setBackgroundImage(image(withColor: UIColor.systemPink), for: .selected);
            
            if indexPath.row < offset {
                cell.btnDate.isHidden = true;
            }
            
            if calendar.component(.month, from: Date()) == currentMonth {
                if (indexPath.row + 1 - offset) == currentDay {
                    cell.btnDate.tintColor = .red;
                }
            }
            
            cell.date = list[indexPath.row];
            
            return cell;
        }
        
        fatalError("Cannot create date's cell");
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    
    //MARK: FIELDS
    private var calendar = Calendar.current;
    private var currentDay = 1;
    private var currentMonth = 1;
    private var currentYear = 2000;
    
    private var list:[Date] = [Date]();
    private var offset = 0;
    
    @IBOutlet weak var calendarView: CalendarView!
    
    @IBAction func goPrevMonth(_ sender: UIButton) {
        currentMonth -= 1;
        if currentMonth <= 0 {
            currentMonth = 12;
            currentYear -= 1;
        }
        updateCalendar();
    }
    
    @IBOutlet weak var lblCurrentMonth: UILabel!
    
    
    @IBAction func goNextMonth(_ sender: UIButton) {
        currentMonth += 1;
        
        if currentMonth >= 13 {
            currentMonth = 1;
            currentYear += 1;
        }
        updateCalendar();
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentDay = calendar.component(.day, from: Date());
        currentMonth = calendar.component(.month, from: Date());
        currentYear = calendar.component(.year, from: Date());
        
        updateCalendar();
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: METHODS
    private func updateCalendar() {
        lblCurrentMonth.text = "\(currentMonth) - \(currentYear)";
        
        //get list
        var dateComponents = DateComponents()
        dateComponents.year = currentYear
        dateComponents.month = currentMonth
        dateComponents.day = 1
        let firstDayOfMonth = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!;
        let numDaysInMonth = range.count;
        
        list.removeAll();
        
        for day in 1...numDaysInMonth {
            dateComponents.day = day
            let date = calendar.date(from: dateComponents)!
            list.append(date);
        }
        
        offset = calendar.component(.weekday, from:list[0]);
        
        offset = offset == 1 ? 6 : offset - 2;
        
        if offset > 0 {
            for _ in 1...offset {
                list = [Date()] + list;
            }
        }
        
        calendarView.reloadData();
        
    }
    
    func image(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }


}
