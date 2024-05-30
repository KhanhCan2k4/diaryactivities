//
//  TodoDAO.swift
//  DemoWeatherApp
//
//  Created by MAC on 22/5/24.
//

import Foundation
import os.log

class TodoDAO : DatabaseDAO {
    public static let TABLE_NAME = "todos";
    
    public static let ID = "_id";
    public static let NAME = "name";
    public static let DATE = "date";
    public static let IN_TRASH = "in_trash";
    
    public static let CREATE_STATEMENT = "CREATE TABLE \(TABLE_NAME)("
        + "\(ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
        + "\(NAME) TEXT, "
        + "\(IN_TRASH) INTEGER DEFAULT 0 NOT NULL, "
        + "\(DATE) INTEGER)";
    
    public static func all(todos: inout [Todo]) {
        if super.open() {
            todos.removeAll();
            
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(IN_TRASH) = 0 ORDER BY \(DATE) DESC";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: nil);
                
                while result!.next() {
                    let todo = Todo();
                    todo.id = Int(result!.int(forColumn: "\(ID)"))
                    todo.name = result!.string(forColumn: "\(NAME)")!
                    todo.date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                    
                    todos.append(todo);
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
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(IN_TRASH) = 0 ORDER BY \(DATE) DESC";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: nil);
                
                while result!.next() {
                    let id = Int(result!.int(forColumn: "\(ID)"))
                    let date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                    
                    resultStr = resultStr
                    + "\n-----------------------------------------------------------\n"
                    + "\tNgày tạo: \(date)\n"
                    + "\tCác công việc:\n";
                    
                    var result2:FMResultSet?
                    let sql2 = "SELECT * FROM \(NoteDAO.TABLE_NAME) WHERE \(NoteDAO.TODO_ID) = ? AND \(NoteDAO.IN_TRASH) = 0 ORDER BY \(NoteDAO.DATE) DESC";
                    
                    do{
                        result2 = try super.database!.executeQuery(sql2, values: [id]);
                        
                        while result2!.next() {
                            let name = result2!.string(forColumn: "\(NoteDAO.NAME)")!;
                            let content = result2!.string(forColumn: "\(NoteDAO.CONTENT)")!;
                            let date = Date(timeIntervalSince1970: TimeInterval(result2!.int(forColumn: "\(NoteDAO.DATE)"))).formatted(date: .complete, time: .standard);
                            
                            resultStr = resultStr
                            + "\t\t***\n"
                            + "\t\tNgày thực hiện: \(date)\n"
                            + "\t\tCông việc: \(name)\n"
                            + "\n";
                        }
                    }
                    catch{
                        os_log("khong the truy van co so du lieu");
                    }
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
        
        return resultStr;
    }
    
    public static func getTodosByDate(date:Date, todos: inout [Todo]) {
        if super.open() {
            todos.removeAll();
            
            let sql = "SELECT * FROM \(TABLE_NAME) ORDER BY \(DATE) DESC";
            
            let formatedDate = date.formatted(date: .numeric, time: .omitted);
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: nil);
                
                while result!.next() {
                    let todo = Todo();
                    todo.id = Int(result!.int(forColumn: "\(ID)"))
                    todo.name = result!.string(forColumn: "\(NAME)")!
                    todo.date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                    
                    if todo.date.formatted(date: .numeric, time: .omitted).elementsEqual(formatedDate) {
                        todos.append(todo);
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
    
    public static func show(id:Int, todo: inout Todo) {
        if super.open() {
            
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(ID) = ?";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: [id]);
                
                if result!.next() {
                    todo = Todo();
                    todo.id = Int(result!.int(forColumn: "\(ID)"))
                    todo.name = result!.string(forColumn: "\(NAME)")!
                    todo.date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
        
        os_log("khong the truy van co so du lieu");
    }
    
    public static func store(todo:Todo) -> Bool {
        if super.open() {
            let sql = "INSERT INTO \(TABLE_NAME) (\(NAME), \(DATE)) VALUES (?,?)";
            
            if super.database!.executeUpdate(sql, withArgumentsIn: [todo.name, Int(todo.date.timeIntervalSince1970)]) {
                
                todo.id = Int(super.database!.lastInsertRowId);
                
                os_log("them thanh cong")
                return true;
            }
            
            super.close();
        }
        
        os_log("khong the truy van co so du lieu");
        return false;
    }
    
    public static func update(todo:Todo) -> Bool {
        if super.open() {
            let sql = "UPDATE \(TABLE_NAME) SET \(NAME) = ?, \(DATE) = ? WHERE \(ID) = ?";
            
            if super.database!.executeUpdate(sql, withArgumentsIn: [todo.name, Int(todo.date.timeIntervalSince1970), todo.id]) {
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
    
    public static func getTodosInTrash(todos: inout [Todo]) {
        if super.open() {
            todos.removeAll();
            
            let sql = "SELECT * FROM \(TABLE_NAME) WHERE \(IN_TRASH) = 1 ORDER BY \(DATE) DESC  ";
            
            var result:FMResultSet?
            do{
                result = try super.database!.executeQuery(sql, values: nil);
                
                while result!.next() {
                    let todo = Todo();
                    todo.id = Int(result!.int(forColumn: "\(ID)"));
                    todo.name = result!.string(forColumn: "\(NAME)")!;
                    todo.date = Date(timeIntervalSince1970: TimeInterval(result!.int(forColumn: "\(DATE)")));
                    todo.inTrash = 1;
                    todos.append(todo);
                }
            }
            catch{
                os_log("khong the truy van co so du lieu");
            }
            
            super.close();
        }
    }
}
