//
//  TextNoteController.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import UIKit

class TextNoteController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var note:Note?;
    
    @IBAction func stopView(_ sender: UIBarButtonItem) {
        dismiss(animated: true);
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let title = txtTitle.text, let content = txtContent.text {
            if title.isEmpty{
                let alert = UIAlertController(title: "Lỗi tiêu đề", message: "Tiêu đề không được để trống!", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { _ in
                    self.dismiss(animated: true);
                }));
                self.present(alert, animated: true, completion: nil);
                return ;
            }
            if let activtivitiesController = self.storyboard!.instantiateViewController(withIdentifier: "ActivitiesController") as? ActivitiesController {
                if isEdit == true {
                    note!.name = title
                    note!.content = content
                    
                    // Thuc hien chinh sua
                    // 1. mo database
                    DatabaseDAO.initDatabase(); // khoi tao db
                    
                    if note!.inTrash == 1 ? NoteDAO.refresh(id: note!.id) : NoteDAO.update(note: note!) {
                        let alert = UIAlertController(title: "Sửa ghi chú", message: "Sửa ghi chú thành công", preferredStyle: .alert);
                        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { _ in
                            self.dismiss(animated: true);
                        }));
                        self.present(alert, animated: true, completion: nil);
                    }
                    
                }
                else{
                    note = Note();
                    note!.name = title
                    note!.content = content
                    
                    // 1. mo database
                    DatabaseDAO.initDatabase();
                    
                    // 2. them note vao db
                    if NoteDAO.store(note: note!) {
                        let alert = UIAlertController(title: "Thêm ghi chú", message: "Thêm ghi chú thành công\n(Mẹo: tải lại trang để hiện ghi chú mới!)", preferredStyle: .alert);
                        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { _ in
                            self.dismiss(animated: true);
                        }));
                        self.present(alert, animated: true, completion: nil);
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var date: UILabel!
    var isEdit = false;
    
    // ham uy quyen txtTitle
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true);
        return false;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        print(textField.text)
        note!.name = textField.text!;
    }
    
    
    // ham uy quyen txtContent
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        //        print(textView.text)
        note!.content = textView.text;
        return true;
    }
    
    
    @IBOutlet var btnSave: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // buoc goi uy quyen
        txtTitle.delegate = self;
        txtContent.delegate = self;
        
        // kiem tra ne
        if let note = note {
            isEdit = true;
            date.text = note.date.formatted(date: .long, time: .standard)
            txtTitle.text = note.name;
            print("hihi: \(note.content)")
            txtContent.text = note.content;
            
            if note.inTrash == 1 {
                btnSave.tintColor = .red;
            }
            
        } else {
            isEdit = false;
            note = Note();
            date.text = note!.date.formatted(date: .long, time: .standard)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigationTieu de
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
