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
    public var todoController:TodosController?;
    
    @IBAction func editTodo(_ sender: Any) {
        if let activitiesController = self.activitiesController {
            self.activitiesController!.toGoTextTodoView(todo:todo);
        } else if let todoController = self.todoController {
            if let textTodoController =  self.todoController!.storyboard!.instantiateViewController(withIdentifier: "TextTodoController") as? TextTodoController {
                textTodoController.isEdit = true;
                textTodoController.todo = todo;
                
                self.todoController!.present(textTodoController, animated: true);
            }
        }
        
    }
    
    
    @IBAction func deleteTodo(_ sender: UIButton) {
        // 1. mo db
        DatabaseDAO.initDatabase();
        
        // 2. xoa trong db
        if let todo = self.todo {
            let alert = UIAlertController(title: "Xoá danh sách công việc", message: "Xác nhận xoá danh sách công việc", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Xoá", style: .default, handler: { _ in
                
                let isDeleted = ((self.todoController != nil) && self.todoController!.isRefreshed && TodoDAO.destroy(id: todo.id)) || TodoDAO.moveToTrash(id: todo.id) ;
                
                if  isDeleted {
                    
                    if let activitiesController = self.activitiesController {
                        TodoDAO.all(todos: &self.activitiesController!.todoesList)
                        self.activitiesController!.todoesView.reloadData();
                    } else if let todoController = self.todoController {
                        if todoController.isRefreshed {
                            TodoDAO.getTodosInTrash(todos: &self.todoController!.todoes)
                        } else {
                            TodoDAO.all(todos: &self.todoController!.todoes)
                        }
                        
                        self.todoController!.todoView.reloadData();
                    }

                    let alertD = UIAlertController(title: "Xoá danh sách công việc", message: "Xoá danh sách công việc thành công", preferredStyle: .alert);
                    alertD.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil));
 
                    
                    if let activitiesController = self.activitiesController {
                        self.activitiesController!.present(alertD, animated: true, completion: nil);
                    } else if let todoController = self.todoController {
                        self.todoController!.present(alertD, animated: true, completion: nil);
                    }
                }
            }));
            
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil));
            
            if let activitiesController = activitiesController {
                activitiesController.present(alert, animated: true, completion: nil);
            } else if let todoController = todoController {
                todoController.present(alert, animated: true, completion: nil);
            }
            
        }
        
    }
}
