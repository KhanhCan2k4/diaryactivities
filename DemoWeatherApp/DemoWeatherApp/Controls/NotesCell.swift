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
    public var notesController:NotesController?;
    
    @IBAction func deleteNote(_ sender: Any) {
        // 1. mo db
        DatabaseDAO.initDatabase();
        
        // 2. xoa trong db
        if let note = note {
            let alert = UIAlertController(title: "Xoá ghi chú", message: "Xác nhận xoá ghi chú", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Xoá", style: .default, handler: { _ in
                
                let isDeleted = ((self.notesController != nil) && self.notesController!.isRefreshed && NoteDAO.destroy(id: note.id)) || NoteDAO.moveToTrash(id: note.id);
                
                if isDeleted {
                   
                    if let activitiesController = self.activitiesController {
                        NoteDAO.getNotesByInTodo(todoID: 0, notes: &self.activitiesController!.notesList)
                        self.activitiesController!.notesView.reloadData();
                    } else if let notesController = self.notesController {
                        if notesController.isRefreshed {
                            NoteDAO.getNotesInTrash(notes: &self.notesController!.notes)
                        } else {
                            NoteDAO.getNotesByInTodo(todoID: 0, notes: &self.notesController!.notes)
                        }
                        
                        self.notesController!.notesView.reloadData();
                    }
                    
                    let alertD = UIAlertController(title: "Xoá ghi chú", message: "Xoá ghi chú thành công", preferredStyle: .alert);
                    alertD.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil));
                    
                    if let activitiesController = self.activitiesController {
                        self.activitiesController!.present(alertD, animated: true, completion: nil);
                    } else if let notesController = self.notesController {
                        self.notesController!.present(alertD, animated: true, completion: nil);
                    }
                    
                }
            }));
            
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil));
            
            if let activitiesController = self.activitiesController {
                self.activitiesController!.present(alert, animated: true, completion: nil);
            } else if let notesController = self.notesController {
                self.notesController!.present(alert, animated: true, completion: nil);
            }
            
        }
    }
    
    @IBAction func editNote(_ sender: Any) {
        if let activitiesController = self.activitiesController {
            self.activitiesController!.toGoTextNoteView(note:note);
        } else if let notesController = self.notesController {
            if let textTodoController =  self.notesController!.storyboard!.instantiateViewController(withIdentifier: "TextNoteController") as? TextNoteController {
                textTodoController.isEdit = true;
                textTodoController.note = note;
                
                self.notesController!.present(textTodoController, animated: true);
            }
        }
    }
}
