//
//  Timer.swift
//  Mytimer
//
//  Created by Yuki Shinohara on 2021/01/23.
//

import Foundation
import RealmSwift

class MyTimer: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var date: String = "" 
    
    override static func primaryKey() -> String? {
      return "id"
    }
}
