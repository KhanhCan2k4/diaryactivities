//
//  Database.swift
//  DemoWeatherApp
//
//  Created by MAC on 22/5/24.
//

import Foundation
import os.log

class DatabaseDAO {
    //MARK: cac thuoc tinh chung cua co so du lieu
    private static let DB_NAME = "daily_activities_db.sqlite"
    private static var DB_PATH:String?
    internal static var database:FMDatabase? = nil;
    
    //MARK: consrtructors
    public static func initDatabase() {
        //lay tat ca duong dan den cac thu muc document trong mot ung dung ios
     let directiores =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        //khoi tao DB_PATH
        DB_PATH = directiores[0] + "/" + DB_NAME
        
        //khoi tao doi tuong database
        database = FMDatabase(path: DB_PATH)
        
        //kiem tra su thanh cong cua database
        if database != nil{
            os_log("Tao CSDL thanh cong")
            
            //thuc hien tao cac bang du lieu
            if open(){
                if !database!.tableExists(TodoDAO.TABLE_NAME){
                    let _ = createTable(sql: TodoDAO.CREATE_STATEMENT);
                }
                if !database!.tableExists(NoteDAO.TABLE_NAME){
                    let _ = createTable(sql: NoteDAO.CREATE_STATEMENT);
                }
                close();
            }
           
        } else {
            os_log("Tao CSDL khong thanh cong")
        }
    }
    
    //////////////
    // MARK: dinh nghia cac ham primitives cua CSDL
    /////////////
    ///1. Mo CSDL
    internal static func open()->Bool{
        var OK = false
        if database != nil{
            if let database = database {
                if database.open(){
                    os_log("mo CSDL thanh cong")
                    OK = true
                }
                else
                {
                    os_log("mo CSDL khong thanh cong")
                }
            }
        }
        return OK
    }
   
    //2. dong co so du lieu
    internal static func close(){
        if let database = database{
            database.close()
        }
    }
    
    //3. Tao bang du lieu
    internal static func createTable(sql:String)->Bool{
        var OK = false
        if open(){
            if database!.executeStatements(sql)
            {
                os_log("tao bang CSDL  thanh cong")
                OK = true
            }else {
                os_log("tao bang CSDL khong thanh cong")
            }
            
        }
        return OK
    }
    
}
