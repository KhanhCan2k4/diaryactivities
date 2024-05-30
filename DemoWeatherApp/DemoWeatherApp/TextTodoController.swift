//
//  TextTodoController.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import UIKit

class TextTodoController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var todo:Todo?;
    var isEdit = false;
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let todo = todo {
            return todo.todos.count ?? 0;
        }
        
        return 0;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "AddToDoCell"
        if let cell = addTodoView.dequeueReusableCell(
            withReuseIdentifier: reuseCell,
            for: indexPath
        ) as? AddToDoCell, let todo = self.todo {
            //lay phan tu thu i trong mang
            let todo = todo.todos[indexPath.row]
            
            cell.dataPicker.date = todo.date
            cell.label.text = cell.getDateToString();
            cell.content.text = todo.name
            
            cell.configureDatePicker();
            cell.getDateAffter(3, .day, from: Date())
            
            // luu lai cell de chay, (khong luu la khong chay)
            cell.index = indexPath.row;
            cell.addTodoController = self;
            
            // uy quyen cho textField
            cell.content.delegate = cell.self // uy quye cho thang con trong collectionView
            
            return cell
        }
        fatalError(
            "khong the tao cell!"
        )
    }
    
    @IBAction func stopView(_ sender: UIBarButtonItem) {
        dismiss(animated: true);
    }
    
    
    @IBAction func addToDo(_ sender: UIButton) {
        todo!.todos.append(Note())
        addTodoView.reloadData();
    }
    
    @IBOutlet weak var addTodoView: AddToDoView!
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if self.isEdit == true {
            // Thuc hien chinh sua
            // 1. mo db
            DatabaseDAO.initDatabase();
            
            // 2. them todo vao db
            if let todo = self.todo {
                if todo.inTrash == 1 ? TodoDAO.refresh(id: todo.id) : TodoDAO.update(todo: todo) {
                    // xoa -> luu lai tat ca cac task
                    for i in 0..<todo.todos.count {
                        let t = todo.todos[i];
                        t.todoId = todo.id;
                        
                        // luu len db
                        NoteDAO.destroy(id: t.id);
                        NoteDAO.store(note: t);
                    }
                    
                    let alert = UIAlertController(title: "Sửa danh sách công việc", message: "Sửa danh sách công việc thành công\n(Mẹo: tải lại trang để hiện danh sách mới!)", preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { _ in
                        self.dismiss(animated: true);
                    }));
                    self.present(alert, animated: true, completion: nil);
                } else {
                    let alert = UIAlertController(title: "Sửa danh sách công việc", message: "Sửa danh sách công việc không thành công", preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { _ in
                        // cap nhat lai db
                        self.dismiss(animated: true);
                    }));
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
        else{
            // Thuc hien them
            //            print(todoController!.todo!.todos)
            // 1. mo db
            DatabaseDAO.initDatabase();
            
            // 2. them todo vao db
            if let todo = self.todo {
                
                if TodoDAO.store(todo: todo) {
                    // luu tat ca cac task
                    for i in 0..<todo.todos.count {
                        let t = todo.todos[i];
                        t.todoId = todo.id;
                        
                        NoteDAO.store(note: t)
                    }
                    
                    let alert = UIAlertController(title: "Thêm danh sách công việc", message: "Thêm danh sách công việc thành công\n(Mẹo: tải lại trang để hiện danh sách mới!)", preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { _ in
                        self.dismiss(animated: true);
                    }));
                    self.present(alert, animated: true, completion: nil);
                    
                } else {
                    let alert = UIAlertController(title: "Thêm danh sách công việc", message: "Thêm danh sách công việc không thành công", preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { _ in
                        // cap nhat lai db
                        self.dismiss(animated: true);
                    }));
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }
    
    
    @IBOutlet var btnSave: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if todo != nil {
            isEdit = true;
            // chuan bi du lieu de cap nhat ne
            NoteDAO.getNotesByInTodo(todoID: todo!.id, notes: &todo!.todos)
            addTodoView.reloadData();
            
            if todo!.inTrash == 1 {
                btnSave.tintColor = .red;
            }
        } else {
            isEdit = false;
            todo = Todo();
            todo!.todos.append(Note())
        }
    }
    
}
