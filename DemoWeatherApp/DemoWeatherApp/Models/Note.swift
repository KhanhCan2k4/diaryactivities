//
//  Note.swift
//  DemoWeatherApp
//
//  Created by MAC on 20/5/24.
//

import Foundation

class Note {
    public var id:Int;
    public var name:String;
    public var date:Date;
    public var content:String;
    public var todoId:Int = 0;
    
    init(id: Int, name: String, content:String, date: Date) {
        self.name = name;
        self.date = date;
        self.content = content;
        self.id = 0
    }
    
    init(id: Int, name: String, date: Date) {
        self.name = name;
        self.date = date;
        self.content = "";
        self.id = 0
    }
    
    init(name: String, date: Date) {
        self.name = name;
        self.date = date;
        self.content = "";
        self.id = 0
    }
    
    init(name: String) {
        self.name = name;
        self.date = Date();
        self.content = "";
        self.id = 0
    }
    
    init() {
        self.name = "";
        self.date = Date();
        self.content = "";
        self.id = 0;
    }
}
