//
//  PinTodoDAO.swift
//  DemoWeatherApp
//
//  Created by MAC on 23/5/24.
//

import Foundation


class PinTodoDAO {
    public static let TABLE_NAME = "pin_todos";
    public static let ID = "_id";
    public static let TODO_ID = "todo_id";
    
    public static let CREATE_STATEMENT = "CREATE TABLE \(TABLE_NAME)("
        + "\(ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
        + "\(TODO_ID) INTEGER, "
        + "FOREIGN KEY(\(TODO_ID)) REFERENCES \(TodoDAO.TABLE_NAME)(\(TodoDAO.ID)) )";
    
    public static func all(todos:[Todo]) {
        
    }
    
}
