//
//  todo.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import Foundation
class Todo{
    public var id:Int;
    public var name:String;
    public var date:Date;
    public var todos:[Note];
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
        self.id = 0;
        self.todos = [Note]();
    }
    
    init() {
        self.id = 0;
        self.name = ""
        self.date = Date()
        self.todos = [Note]();
    }
}
