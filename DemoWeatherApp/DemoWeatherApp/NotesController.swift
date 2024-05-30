//
//  NotesController.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import UIKit

class NotesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var notes:[Note] = [Note]();
    public var isRefreshed = false;
    
    
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
            cell.notesController = self;
            cell.note = note;
            
            return cell;
        }
        
        fatalError("Cannot create date's cell");
    }
    
    //MARK: FIELDS
    @IBAction func stopView(_ _: UIBarButtonItem) {
        dismiss(animated: true);
    }
    
    
    
    @IBAction func refresh(_ sender: UIButton) {
        reload();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        reload();
    }
    
    private func reload() {
        //khoi tao database
        DatabaseDAO.initDatabase();
        
        //lay tat ca cac notes tu database
        if self.isRefreshed {
            NoteDAO.getNotesInTrash(notes: &self.notes);
        } else {
            NoteDAO.getNotesByInTodo(todoID: 0, notes: &self.notes);
        }
        
        self.notesView.reloadData();
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
