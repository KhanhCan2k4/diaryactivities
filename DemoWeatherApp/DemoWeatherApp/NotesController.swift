//
//  NotesController.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import UIKit

class NotesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var notes:[Note] = [Note]();
    
    
    @IBOutlet weak var notesView: NotesView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notes.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    //tao ra con
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCell", for: indexPath) as? NotesCell {
            
            let note = self.notes[indexPath.row];
            
            cell.name.text = note.name;
            cell.date.text = note.date.formatted(date: .long, time: .standard);
            
            return cell;
        }
        
        fatalError("Cannot create date's cell");
    }
    
    //MARK: FIELDS
    @IBAction func stopView(_ _: UIBarButtonItem) {
        dismiss(animated: true);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //khoi tao database
        DatabaseDAO.initDatabase();

        // Do any additional setup after loading the view.
//        let note1 = Note(name: "Note 1", date: Date());
//        let note2 = Note(name: "Note 2", date: Date());
//        let note3 = Note(name: "Note 3", date: Date());
//        let note4 = Note(name: "Note 4", date: Date());
//        
//        if NoteDAO.store(note: note1) {
//            print("Them \(note1.name) thanh cong");
//        }
//        if NoteDAO.store(note: note2) {
//            print("Them \(note1.name) thanh cong");
//        }
//        if NoteDAO.store(note: note3) {
//            print("Them \(note1.name) thanh cong");
//        }
//        if NoteDAO.store(note: note4) {
//            print("Them \(note1.name) thanh cong");
//        }
        
        //lay tat ca cac notes tu database
        NoteDAO.all(notes: &self.notes)
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
