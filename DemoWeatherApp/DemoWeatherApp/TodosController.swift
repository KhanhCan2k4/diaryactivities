//
//  TodosController.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import UIKit

class TodosController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var todoView: TodoesView!
    var todoes:[Todo] = [Todo]();
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoes.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoesCell", for: indexPath) as? TodoesCell {
            
            let todo = self.todoes[indexPath.row];
            
            cell.name.text = todo.name
            cell.date.text = todo.date.formatted(date: .long, time: .standard)
            cell.totalTodo.text = "Tổng cộng: \(NoteDAO.getNotesByInTodoToTal(todoID: todo.id))";
            
            cell.todoController = self;
            cell.todo = todo;
            
            return cell;
        }
        fatalError("Cannot create date's cell");
    }
    
    //MARK: FIELDS
    public var isRefreshed = false;
    
    @IBAction func stopView(_ sender: UIBarButtonItem) {
        dismiss(animated: true);
    }
    
    
    @IBAction func refresh(_ sender: UIButton) {
        reload();
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        reload();
    }
    
    private func reload() {
        DatabaseDAO.initDatabase();
        
        if isRefreshed {
            TodoDAO.getTodosInTrash(todos: &self.todoes)
        } else {
            TodoDAO.all(todos: &self.todoes);
        }
        
        self.todoView.reloadData();
    }

}
