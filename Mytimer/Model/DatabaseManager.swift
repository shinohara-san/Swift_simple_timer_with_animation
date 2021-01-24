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
    
    func deleteTimer(selectedTimer: MyTimer, completion: @escaping (Bool) -> Void){
        do {
            let realm = try Realm()
            guard let data = realm.objects(MyTimer.self)
                    .filter("id == '\(selectedTimer.id)'")
                    .first else {return}
            try realm.write({
                realm.delete(data)
                completion(true)
            })
        } catch let error as NSError {
            print(error)
            completion(false)
        }
    }
}
