//
//  NotesCell.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import UIKit

class NotesCell: UICollectionViewCell {
    var note:Note?;
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var editNote: UIButton!
    @IBOutlet weak var deleteNote: UIButton!
    @IBOutlet weak var date: UILabel!
    public var activitiesController:ActivitiesController?;
    
    @IBAction func deleteNote(_ sender: Any) {
        // 1. mo db
        DatabaseDAO.initDatabase();
        
        // 2. xoa trong db
        if let note = note {
            let alert = UIAlertController(title: "Xoá ghi chú", message: "Xác nhận xoá ghi chú", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Xoá", style: .default, handler: { _ in
                if NoteDAO.destroy(id: note.id) {
                    NoteDAO.getNotesByInTodo(todoID: 0, notes: &self.activitiesController!.notesList)
                    self.activitiesController!.notesView.reloadData();
                    
                    let alertD = UIAlertController(title: "Xoá ghi chú", message: "Xoá ghi chú thành công", preferredStyle: .alert);
                    alertD.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil));
                    
                    self.activitiesController!.present(alertD, animated: true, completion: nil);
                }
            }));
            
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil));
            
            activitiesController!.present(alert, animated: true, completion: nil);
        }
    }
    
    @IBAction func editNote(_ sender: Any) {
        editNote.isSelected = true;
        
        self.activitiesController!.toGoTextNoteView(note:note);
        
        editNote.isSelected = false;
    }
}
