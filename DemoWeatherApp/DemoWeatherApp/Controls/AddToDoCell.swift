//
//  AddToDoCell.swift
//  DemoWeatherApp
//
//  Created by MAC on 22/5/24.
//

import UIKit


class AddToDoCell: UICollectionViewCell, UITextFieldDelegate {
    
    // luu gia tri de xoa
    var index:Int = 0;
    public var addTodoController:TextTodoController?;
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var content: UITextField!
    
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        label.text = getDateToString();
        addTodoController!.todo!.todos[index].date = self.dataPicker.date
    }
    
    
    @IBAction func deleteToDo(_ sender: UIButton) {
        // day la gia du lieu cho db
        // lay list tu cha va thay doi
        if let todo = addTodoController!.todo, todo.todos.count > 1 {
            // xoa tren db
            let note = todo.todos[index];
            
            NoteDAO.destroy(id: note.id);
            
            // xoa no khoi data src
            todo.todos.remove(at: index);
            addTodoController!.addTodoView.reloadData();
        }
    }
    
    // ham uy quyen txtTitle
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true);
        return false;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addTodoController!.todo!.todos[index].name = textField.text!;
    }
    
    
    // set ngay nho nhat va ngay lon nhat
        func configureDatePicker() {
            dataPicker.minimumDate = Date() // gan ngay nho nhat la ngay hom nay
            guard let maximumDate = getDateAffter(3, .day, from: Date()) else {
                return;
            }
            dataPicker.maximumDate = maximumDate
        }
        
        // kieu la sau 1 ngay 10 ngay hay 1h no se lam
        func getDateAffter(_ value:Int, _ type: Calendar.Component, from date: Date) -> Date?{
            return Calendar.current.date(byAdding: type, value: value, to: date)
        }
        
        // chuyen ve kieu string cho no chinh
        func getDateToString() -> String {
            let dataFormater = DateFormatter()
            dataFormater.dateFormat = "dd/MM, hh:mm"
            return dataFormater.string(from: dataPicker.date)
        }
    
}
