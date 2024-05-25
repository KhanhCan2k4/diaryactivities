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
                cell.totalTodo.text = "\(todo.todos.count)"
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
            }
        }
    }
    @IBAction func IncreaseDayTapped(_ sender: Any) {
        // Tang ngày hiện tại len 1 ngày
        if let date = currentDate {
            currentDate = Calendar.current.date(byAdding: .day, value: +1, to: date)
            if let newDate = currentDate {
                updateDateLabel(with: newDate)
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
        
        updateDateLabel(with: currentDate)
        reloadData();
    }
    
    public func reloadData() {
        TodoDAO.all(todos: &self.todoesList)
        NoteDAO.getNotesByInTodo(todoID: 0, notes: &self.notesList)
        self.notesView.reloadData();
        self.todoesView.reloadData();
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func unwindFromTodo(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let todoController = unwindSegue.source as? TextTodoController
        if todoController!.isEdit == true {
            // Thuc hien chinh sua
            // 1. mo db
            DatabaseDAO.initDatabase();
            
            // 2. them todo vao db
            if let todo = todoController!.todo {
                
                TodoDAO.update(todo: todo);
                
                // luu tat ca cac task
                for i in 0..<todo.todos.count {
                    let t = todo.todos[i];
                    t.todoId = todo.id;
                    
                    // luu len db
                    NoteDAO.update(note: t)
                }
                
                // cap nhat laindb
                TodoDAO.all(todos: &todoesList);
                todoesView.reloadData();
            }
        }
        else{
            // Thuc hien them
//            print(todoController!.todo!.todos)
            // 1. mo db
            DatabaseDAO.initDatabase();
            
            // 2. them todo vao db
            if let todo = todoController!.todo {
                
                if TodoDAO.store(todo: todo) {
                    // luu tat ca cac task
                    for i in 0..<todo.todos.count {
                        let t = todo.todos[i];
                        t.todoId = todo.id;
                        
                        // luu len db
                        NoteDAO.store(note: t);
                    }
                    
                    //hien thong bao
                    let alert = UIAlertController(title: "Thêm danh sách công việc", message: "Thêm danh sách công việc thành công\n(Mẹo: tải lại trang để hiện danh sách mới!)", preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { _ in
                        // cap nhat lai db
                        TodoDAO.all(todos: &self.todoesList);
                        self.todoesView.reloadData();
                    }));
                    self.present(alert, animated: true, completion: nil);
                }
            } else {
                //hien thong bao
                let alert = UIAlertController(title: "Thêm danh sách công việc", message: "Thêm danh sách công việc không thành công", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil));
                self.present(alert, animated: true, completion: nil);
            }
        }
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
                self.present(noteController, animated: true);
            }
        }
        
        let refesh = UIAction(title: "Tải lại", image: UIImage(systemName: "arrow.clockwise.circle.fill")) { _ in
            self.reloadData();
        }
        
        let menu = UIMenu(title: "Hoạt động", children: [add, history, refesh])
        self.pullDownButtonNote.menu = menu
        self.pullDownButtonNote.showsMenuAsPrimaryAction = true
    }
    
    func setUpMenuForTodos() {
        let add = UIAction(title: "Thêm", image: UIImage(systemName: "plus")) { _ in
            if let noteController =  self.storyboard!.instantiateViewController(identifier: "TextTodoController") as? TextTodoController {
                self.present(noteController, animated: true);
            }
        }
        
        let history = UIAction(title: "Thùng rác", image: UIImage(systemName: "arrow.up.trash.fill")) { _ in
            if let noteController =  self.storyboard!.instantiateViewController(identifier: "TodosController") as? TodosController {
                self.present(noteController, animated: true);
            }
        }
        
        let refesh = UIAction(title: "Tải lại", image: UIImage(systemName: "arrow.clockwise.circle.fill")) { _ in
            self.reloadData();
        }
        
        let menu = UIMenu(title: "Hoạt động", children: [add, history, refesh])
        self.pullDownButtonTodo.menu = menu
        self.pullDownButtonTodo.showsMenuAsPrimaryAction = true
    }
}
