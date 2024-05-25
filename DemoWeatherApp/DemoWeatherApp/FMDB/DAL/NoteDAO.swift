//
//  NoteDAO.swift
//  DemoWeatherApp
//
//  Created by MAC on 22/5/24.
//

import Foundation
import os.log

class NoteDAO : DatabaseDAO {
    public static let TABLE_NAME = "notes";
    
    public static let ID = "_id";
    public static let NAME = "name";
    public static let DATE = "date";
    public static let CONTENT  = "content";
    public static let TODO_ID  = "todo_id";
    
    public static let CREATE_STATEMENT = "CREATE TABLE \(TABLE_NAME)("
        + "\(ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
        + "\(NAME) TEXT, "
        + "\(CONTENT) TEXT, "
        + "\(DATE) INTEGER, "
        + "\(TODO_ID) INTEGER, "
        + "FOREIGN KEY(\(TODO_ID)) REFERENCES \(TodoDAO.TABLE_NAME)(\(TodoDAO.ID)) )";
    
    public static func all(notes: inout [Note]) {
        if super.open() {
            notes.removeAll();
            
            let sql = "SELECT * FROM \(TABLE_NAME) ORDER BY \(DATE) DESC";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: nil);
                
                while result!.next() {
                    let note = Note();
                    note.id = Int(result!.int(forColumn: "\(ID)"));
                    note.name = result!.string(forColumn: "\(NAME)")!;
                    note.content = result!.string(forColumn: "\(CONTENT)")!;
                    note.date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                    note.todoId = Int(result!.int(forColumn: "\(TODO_ID)"));
                    
                    notes.append(note);
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
    }
    
    public static func getNotesByDate(date:Date, notes: inout [Note]) {
        if super.open() {
            notes.removeAll();
            
            let sql = "SELECT * FROM \(TABLE_NAME)";
            
            let formatedDate = date.formatted(date: .numeric, time: .omitted);
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: nil);
                
                while result!.next() {
                    let note = Note();
                    note.id = Int(result!.int(forColumn: "\(ID)"));
                    note.name = result!.string(forColumn: "\(NAME)")!;
                    note.content = result!.string(forColumn: "\(CONTENT)")!;
                    note.date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                    note.todoId = Int(result!.int(forColumn: "\(TODO_ID)"));
                    
                    if note.date.formatted(date: .numeric, time: .omitted).elementsEqual(formatedDate) {
                        notes.append(note);
                    } //ignore
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
        
        os_log("khong the truy van co so du lieu");
    }
    
    public static func getNotesByInTodo(todoID:Int, notes: inout [Note]) {
        if super.open() {
            notes.removeAll();
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(TODO_ID) = ? ORDER BY \(DATE) DESC";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: [todoID]);
                
                while result!.next() {
                    let note = Note();
                    note.id = Int(result!.int(forColumn: "\(ID)"));
                    note.name = result!.string(forColumn: "\(NAME)")!;
                    note.content = result!.string(forColumn: "\(CONTENT)")!;
                    note.date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                    note.todoId = Int(result!.int(forColumn: "\(TODO_ID)"));
                    
                    notes.append(note);
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
    }
    
    public static func show(id:Int, note: inout Note){
        if super.open() {
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(ID) = ?";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: [id]);
                
                if result!.next() {
                    note = Note();
                    note.id = Int(result!.int(forColumn: "\(ID)"));
                    note.name = result!.string(forColumn: "\(NAME)")!;
                    note.date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                    note.todoId = Int(result!.int(forColumn: "\(TODO_ID)"));
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
        
        os_log("khong the truy van co so du lieu");
    }
    
    public static func store(note:Note) -> Bool {
        if super.open() {
            let sql = "INSERT INTO \(TABLE_NAME) (\(NAME), \(DATE), \(CONTENT), \(TODO_ID)) VALUES (?,?,?,?)";
            
            if super.database!.executeUpdate(sql, withArgumentsIn: [note.name, Int(note.date.timeIntervalSince1970), note.content, note.todoId]) {
                os_log("them thanh cong")
                return true;
            }
            
            super.close();
        }
        
        os_log("khong the truy van co so du lieu");
        return false;
    }
    
    public static func update(note:Note) -> Bool {
        if super.open() {
            let sql = "UPDATE \(TABLE_NAME) SET \(NAME) = ?, \(DATE) = ?, \(CONTENT) = ?, \(TODO_ID) = ? WHERE \(ID) = ?";
            
            if super.database!.executeUpdate(sql, withArgumentsIn: [note.name, Int(note.date.timeIntervalSince1970), note.content, note.todoId, note.id]) {
                os_log("cap nhat thanh cong")
                return true;
            }
            
            super.close();
        }
        
        os_log("khong the truy van co so du lieu");
        return false;
    }
    
    public static func destroy(id:Int) -> Bool {
        
        if super.open() {
            let sql = "DELETE FROM \(TABLE_NAME) WHERE \(ID) = ?";
            
            if super.database!.executeUpdate(sql, withArgumentsIn: [id]) {
                os_log("xoa thanh cong")
                return true;
            }
            
            super.close();
        }
        
        os_log("khong the truy van co so du lieu");
        return false;
    }
}
