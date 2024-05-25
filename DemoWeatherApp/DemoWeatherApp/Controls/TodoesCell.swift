//
//  TodoesCell.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import UIKit

class TodoesCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var totalTodo: UILabel!
    var todo:Todo?;
    @IBOutlet weak var editTodo: UIButton!
    @IBOutlet weak var deleteTodo: UIButton!
    public var activitiesController:ActivitiesController?;
    
    @IBAction func editTodo(_ sender: Any) {
        self.activitiesController!.toGoTextTodoView(todo:todo);
    }
    
    
    @IBAction func deleteTodo(_ sender: UIButton) {
        // 1. mo db
        DatabaseDAO.initDatabase();
        
        // 2. xoa trong db
        if let todo = self.todo {
            let alert = UIAlertController(title: "Xoá danh sách công việc", message: "Xác nhận xoá danh sách công việc", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Xoá", style: .default, handler: { _ in
                if TodoDAO.destroy(id: todo.id) {
                    TodoDAO.all(todos: &self.activitiesController!.todoesList)
                    self.activitiesController!.todoesView.reloadData();
                    
                    let alertD = UIAlertController(title: "Xoá danh sách công việc", message: "Xoá danh sách công việc thành công", preferredStyle: .alert);
                    alertD.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil));
                    
                    self.activitiesController!.present(alertD, animated: true, completion: nil);
                }
            }));
            
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil));
            
            activitiesController!.present(alert, animated: true, completion: nil);
        }
        
    }
}
