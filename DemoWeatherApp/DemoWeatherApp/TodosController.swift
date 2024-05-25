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
            cell.totalTodo.text = "\(todo.todos.count)"
            
            return cell;
        }
        fatalError("Cannot create date's cell");
    }
    
    //MARK: FIELDS
    
    @IBAction func stopView(_ sender: UIBarButtonItem) {
        dismiss(animated: true);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //khoi tao database
        DatabaseDAO.initDatabase();
        
//        let todo1 = Todo(name: "ăn ", date: Date(), totalTodo: 1)
//        
//        if TodoDAO.store(todo: todo1) {
//            print("Them \(todo1.name) thanh cong");
//        }
        
        //lay tat ca cac todos
        TodoDAO.all(todos: &self.todoes);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
