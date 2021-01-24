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
    
    public var timerArray = [MyTimer]()
    
    public func getAllTimers(for tableView: UITableView){
        do {
          let realm = try Realm()
          let allTimers = realm.objects(MyTimer.self).sorted(byKeyPath: "date", ascending: false)
          timerArray = Array(allTimers)
        } catch let error as NSError {
          print(error)
        }
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    public func saveTimer(newTimer: MyTimer, completion: @escaping (Bool) -> Void){
        if newTimer.title == "" {
            newTimer.title = "名無しのタイマー"
        }
        
        do {
            let realm = try Realm()
            try realm.write{
                realm.add(newTimer)
            }
        } catch let error as NSError {
            print(error)
            completion(false)
        }
        
        completion(true)
    }
    
    func updateTimer(){
        
    }
    
    func deleteTimer(){
        
    }
}
