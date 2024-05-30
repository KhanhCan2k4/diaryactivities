//
//  HomeController.swift
//  DemoWeatherApp
//
//  Created by MAC on 13/5/24.
//

import UIKit
import CoreXLSX

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
            cell.homeController = self;
            
            var frame = cell.btnDate.frame;
            frame.size.width = 50;
            frame.size.height = 50;
            cell.btnDate.frame = frame;
            
            cell.btnDate.setBackgroundImage(image(withColor: UIColor.systemPink), for: .selected);
            
            if indexPath.row < offset {
                cell.btnDate.isHidden = true;
            }
            
            if calendar.component(.month, from: Date()) == currentMonth, 
                calendar.component(.day, from: Date()) == calendar.component(.day, from: list[indexPath.row]),
               calendar.component(.year, from: Date()) == currentYear {
                    cell.btnDate.tintColor = .red;
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let activitiesController =  self.storyboard!.instantiateViewController(withIdentifier: "ActivitiesController") as? ActivitiesController {
            
            present(activitiesController, animated: true);
            
        }
    }
    
    public func toGoActitvitiesView(date:Date) {
        if let activitiesController = self.storyboard!.instantiateViewController(withIdentifier: "ActivitiesController") as? ActivitiesController {
            
            activitiesController.currentDate = date;
            
            present(activitiesController, animated: true)
        }
    }
    
    
    @IBAction func viewDeletedNotes(_ sender: UIButton) {
        if let notesController = self.storyboard!.instantiateViewController(withIdentifier: "NotesController") as? NotesController {
            
            notesController.isRefreshed = true;
            
            present(notesController, animated: true)
        }
    }
    
    
    @IBAction func viewDeletedToDos(_ sender: UIButton) {
        if let todosController = self.storyboard!.instantiateViewController(withIdentifier: "TodosController") as? TodosController {
            
            todosController.isRefreshed = true;
            present(todosController, animated: true)
            todosController.isRefreshed = true;
        }
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
    
    
    @IBAction func exportMyActicities(_ sender: UIButton) {
        let fileName = "Daily Activities.txt";
        
        DatabaseDAO.initDatabase();
        var content = ""
        + "\t\t\t\t\t  G H I  C H Ú\n"
        + "\(NoteDAO.all())"
        + "\n\n"
        + "\t\t\tD A N H  S Á C H  C Ô N G  V I Ệ C \n"
        + "\(TodoDAO.all())"
        + "\n\n";
        
        createAndShareFile(content: content, fileName: fileName, from: self)
    }
    
    func createFileURL(fileName: String) -> URL? {
        let fileManager = FileManager.default
        do {
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return documentsURL.appendingPathComponent(fileName)
        } catch {
            print("Error creating file URL: \(error)")
            return nil
        }
    }
    
    func writeContentToFile(content: String, fileName: String) -> URL? {
        guard let fileURL = createFileURL(fileName: fileName) else {
            return nil
        }
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error writing to file: \(error)")
            return nil
        }
    }

    func presentShareSheet(fileURL: URL, from viewController: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    func createAndShareFile(content: String, fileName: String, from viewController: UIViewController) {
        if let fileURL = writeContentToFile(content: content, fileName: fileName) {
            presentShareSheet(fileURL: fileURL, from: viewController)
        } else {
            print("Failed to create and share file.")
        }
    }

}
