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
    public static let IN_TRASH = "in_trash";
    
    public static let CREATE_STATEMENT = "CREATE TABLE \(TABLE_NAME)("
        + "\(ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
        + "\(NAME) TEXT, "
        + "\(CONTENT) TEXT, "
        + "\(DATE) INTEGER, "
        + "\(TODO_ID) INTEGER, "
        + "\(IN_TRASH) INTEGER DEFAULT 0 NOT NULL, "
        + "FOREIGN KEY(\(TODO_ID)) REFERENCES \(TodoDAO.TABLE_NAME)(\(TodoDAO.ID)) )";
    
    public static func all(notes: inout [Note]) {
        if super.open() {
            notes.removeAll();
            
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(IN_TRASH) = 0 ORDER BY \(DATE) DESC";
            
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
    
    public static func all() -> String {
        var resultStr = "";
        if super.open() {
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(IN_TRASH) = 0 AND \(TODO_ID) = 0 ORDER BY \(DATE) DESC";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: nil);
                
                while result!.next() {
                    let name = result!.string(forColumn: "\(NAME)")!;
                    let content = result!.string(forColumn: "\(CONTENT)")!;
                    let date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)"))).formatted(date: .complete, time: .standard);
                    
                    resultStr = resultStr
                    + "\n-----------------------------------------------------------\n"
                    + "\tNgày tạo: \(date)\n"
                    + "\tTiêu đề: \(name)\n"
                    + "\tNội dung:\n"
                    + "\(content)\n";
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
        
        return resultStr;
    }
    
    public static func getNotesInTrash(notes: inout [Note]) {
        if super.open() {
            notes.removeAll();
            
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(IN_TRASH) = 1 ORDER BY \(DATE) DESC  ";
            
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
                    note.inTrash = 1;
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
            
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(TODO_ID) = 0 AND \(IN_TRASH) = 0 ORDER BY \(DATE) DESC";
            
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
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(TODO_ID) = ? AND \(IN_TRASH) = 0 ORDER BY \(DATE) DESC";
            
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
                    note.inTrash = 0;
                    notes.append(note);
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
    }
    
    public static func getNotesByInTodoToTal(todoID:Int) -> Int {
        var total = 0;
        if super.open() {
            let sql = "SELECT COUNT(*) as total FROM \(TABLE_NAME) WHERE \(TODO_ID) = ? AND \(IN_TRASH) = 0 ORDER BY \(DATE) DESC";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: [todoID]);
                
                while result!.next() {
                    total = Int(result!.int(forColumn: "total"));
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
        
        return total;
    }
    
    public static func getNotesByInTodo(todoID:Int) -> String {
        var resultStr = "";
        if super.open() {
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(TODO_ID) = ? AND \(IN_TRASH) = 0 ORDER BY \(DATE) DESC";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: [todoID]);
                
                while result!.next() {
                    let name = result!.string(forColumn: "\(NAME)")!;
                    let content = result!.string(forColumn: "\(CONTENT)")!;
                    let date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)"))).formatted(date: .complete, time: .standard);
                    
                    resultStr = resultStr
                    + "\t\t***\n"
                    + "\t\tNgày thực hiện: \(date)\n"
                    + "\t\tCông việc: \(name)\n";
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
        return resultStr;
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
    
    public static func moveToTrash(id:Int) -> Bool {
        
        if super.open() {
            let sql = "UPDATE \(TABLE_NAME) SET \(IN_TRASH) = 1 WHERE \(ID) = ?";
            
            if super.database!.executeUpdate(sql, withArgumentsIn: [id]) {
                os_log("đã chuyển vào thùng rác thành công")
                return true;
            }
            
            super.close();
        }
        
        os_log("đã chuyển vào thùng rác không thành công")
        return false;
    }
    public static func refresh(id:Int) -> Bool {
        
        if super.open() {
            let sql = "UPDATE \(TABLE_NAME) SET \(IN_TRASH) = 0 WHERE \(ID) = ?";
            
            if super.database!.executeUpdate(sql, withArgumentsIn: [id]) {
                os_log("Khôi phục thành công")
                return true;
            }
        
            super.close();
        }
    
        os_log("Khôi phục không thành công")
        return false;
    }
}
