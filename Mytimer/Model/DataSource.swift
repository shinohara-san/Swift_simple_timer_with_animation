//
//  DataSource.swift
//  Mytimer
//
//  Created by Yuki Shinohara on 2021/01/23.
//

import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    var allTimers = [MyTimer]()
    
    func getAllTimers(for tableView: UITableView){
        
    }
    
    public func saveTimer(newTimer: MyTimer, completion: @escaping (Bool) -> Void){
        if newTimer.title == "" {
            newTimer.title = "名無しのタイマー"
        }

        let realm = try! Realm()
        try! realm.write {
            realm.add(newTimer)
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        }
        
        completion(true)
    }
    
    func updateTimer(){
        
    }
    
    func deleteTimer(){
        
    }
}
