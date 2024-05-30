//
//  ActivitiesController.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import UIKit

class ActivitiesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var notesList = [Note]();
    var todoesList = [Todo]();
    var date:Date?;
    var currentDate:Date?
    
    @IBAction func goToWeatherView(_ sender: UIButton) {
        if let weatherController = self.storyboard!.instantiateViewController(withIdentifier: "WeatherController") as? WeatherController {
            
            if currentDate != nil {
                weatherController.date = currentDate!;
                weatherController.fetchWeatherAndUpdate();
            }
            
            present(weatherController, animated: true)
        }
    }
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var notesView: NotesView!
    @IBOutlet weak var todoesView: TodoesView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == notesView{
            return notesList.count
        }
        else if collectionView == todoesView{
            return todoesList.count
        }
        else {
            return 0;
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == notesView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCell", for: indexPath) as? NotesCell {
                
                let note = self.notesList[indexPath.row];
                
                cell.name.text = note.name;
                cell.date.text = note.date.formatted(date: .long, time: .standard);
                cell.activitiesController = self
                
                cell.note = note
                
                return cell;
            }
            
            fatalError("Cannot create date's cell");
        }
        else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoesCell", for: indexPath) as? TodoesCell {
                
                let todo = self.todoesList[indexPath.row];
                
                cell.name.text = todo.name
                cell.date.text = todo.date.formatted(date: .long, time: .standard)
                cell.totalTodo.text = "Tổng cộng: \(NoteDAO.getNotesByInTodoToTal(todoID: todo.id))";
                cell.activitiesController = self
                cell.todo = todo;
                
                return cell;
            }
            fatalError("Cannot create date's cell");
        }
    }
    
    
    @IBOutlet weak var pullDownButtonNote: UIButton!
    @IBOutlet weak var pullDownButtonTodo: UIButton!
    @IBAction func stopView(_ sender: UIBarButtonItem) {
        dismiss(animated: true);
    }
    
    public func toGoTextNoteView(note:Note?) {
        print("selected");
        
        
        if let textNoteController =  storyboard!.instantiateViewController(identifier: "TextNoteController") as? TextNoteController {
            
            if let note = note {
                textNoteController.note = note;
            }
            
            present(textNoteController, animated: true);
        }
    }
    
    public func toGoTextTodoView(todo:Todo?) {
        print("selected");
        
        
        if let textTodoController =  storyboard!.instantiateViewController(identifier: "TextTodoController") as? TextTodoController {
            
            if todo != nil{
                textTodoController.todo = todo;
            }
            
            present(textTodoController, animated: true);
        }
    }
    
    @IBAction func decreaseDayTapped(_ sender: Any) {
        // Giảm ngày hiện tại đi 1 ngày
        if let date = currentDate {
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
            if let newDate = currentDate {
                updateDateLabel(with: newDate)
                self.setUpMenuForNotes();
                self.setUpMenuForTodos();
                reloadData();
            }
        }
    }
    @IBAction func IncreaseDayTapped(_ sender: Any) {
            
        if setTimeToMidnight(for: currentDate ?? Date())!.compare(setTimeToMidnight(for: Date())!) == .orderedAscending {
            currentDate = Calendar.current.date(byAdding: .day, value: +1, to: currentDate ?? Date());
            
            if let newDate = currentDate {
                updateDateLabel(with: newDate)
                self.setUpMenuForNotes();
                self.setUpMenuForTodos();
                reloadData();
            }
        }
    }
    func updateDateLabel(with date: Date?) {
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            let formattedDate = dateFormatter.string(from: date!)
            currentDateLabel.text = formattedDate
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseDAO.initDatabase();
        setUpMenuForNotes();
        setUpMenuForTodos();
        
        if currentDate == nil {
            currentDate = Date();
        }
        
        updateDateLabel(with: currentDate)
        
        reloadData();
    }
    
    public func reloadData() {
        TodoDAO.getTodosByDate(date: currentDate ?? Date(), todos: &self.todoesList)
        NoteDAO.getNotesByDate(date: currentDate ?? Date(), notes: &self.notesList)
        self.notesView.reloadData();
        self.todoesView.reloadData();
    }
    
    func setupMenu(pullDownButton:UIButton) {
        let add = UIAction(title: "Thêm", image: UIImage(systemName: "plus")) { _ in
            if pullDownButton == self.pullDownButtonNote{
                if let noteController =  self.storyboard!.instantiateViewController(identifier: "TextNoteController") as? TextNoteController {
                    self.present(noteController, animated: true);
                }
            }
            else if pullDownButton == self.pullDownButtonTodo{
                if let todoController =  self.storyboard!.instantiateViewController(identifier: "TextTodoController") as? TextTodoController {
                    self.present(todoController, animated: true);
                }
            }
            
        }
        
        let menu = UIMenu(title: "Hoạt động", children: [add])
        pullDownButton.menu = menu
        pullDownButton.showsMenuAsPrimaryAction = true
    }
    
    func setUpMenuForNotes() {
        let add = UIAction(title: "Thêm", image: UIImage(systemName: "plus")) { _ in
            if let noteController =  self.storyboard!.instantiateViewController(identifier: "TextNoteController") as? TextNoteController {
                self.present(noteController, animated: true);
            }
        }
        
        let history = UIAction(title: "Thùng rác", image: UIImage(systemName: "arrow.up.trash.fill")) { _ in
            if let noteController =  self.storyboard!.instantiateViewController(identifier: "NotesController") as? NotesController {
                noteController.isRefreshed = true;
                self.present(noteController, animated: true);
            }
        }
        
        let refesh = UIAction(title: "Tải lại", image: UIImage(systemName: "arrow.clockwise.circle.fill")) { _ in
            self.reloadData();
        }
        
        var menu = UIMenu(title: "Hoạt động", children: [add, history, refesh])
        
        if setTimeToMidnight(for: Date())!.compare(setTimeToMidnight(for: currentDate ?? Date())!) != .orderedSame {
            menu = UIMenu(title: "Hoạt động", children: [history, refesh]);
        }
        
        self.pullDownButtonNote.menu = menu
        self.pullDownButtonNote.showsMenuAsPrimaryAction = true
    }
    
    func setTimeToMidnight(for date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)
    }
    
    func setUpMenuForTodos() {
        let add = UIAction(title: "Thêm", image: UIImage(systemName: "plus")) { _ in
            if let noteController =  self.storyboard!.instantiateViewController(identifier: "TextTodoController") as? TextTodoController {
                self.present(noteController, animated: true);
            }
        }
        
        let history = UIAction(title: "Thùng rác", image: UIImage(systemName: "arrow.up.trash.fill")) { _ in
            if let todosController =  self.storyboard!.instantiateViewController(identifier: "TodosController") as? TodosController {
                
                todosController.isRefreshed = true;      
                self.present(todosController, animated: true);
            }
        }
        
        let refesh = UIAction(title: "Tải lại", image: UIImage(systemName: "arrow.clockwise.circle.fill")) { _ in
            self.reloadData();
        }
        
        //get current day
        var menu = UIMenu(title: "Hoạt động", children: [add, history, refesh]);
        
        if setTimeToMidnight(for: Date())!.compare(setTimeToMidnight(for: currentDate ?? Date())!) != .orderedSame {
            menu = UIMenu(title: "Hoạt động", children: [history, refesh]);
        }
 
        self.pullDownButtonTodo.menu = menu
        self.pullDownButtonTodo.showsMenuAsPrimaryAction = true
    }
}
