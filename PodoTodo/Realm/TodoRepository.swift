//
//  Repository.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/07.
//

import Foundation
import RealmSwift

protocol RepositoryType: AnyObject {
//    func fetchFilter(isTodo: Bool, date: Date) -> Results<MainList>
//    func create(_ item: MainList)
//    func update(id: ObjectId, contents: String, date: Date, group: ObjectId)
//    func delete(_ item: MainList)
}

class TodoRepository: RepositoryType {
    
    static let shared = TodoRepository()
    private init() { }
    
    private let realm = try! Realm()
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: ", version)
        } catch {
            print(error)
        }
    }
    
    func fetch() -> Results<MainList> {
        let data = realm.objects(MainList.self)
        return data
    }
    
    func fetchFilter(isTodo: Bool, date: Date, group: ObjectId) -> Results<MainList>? {
        if let startDay = date.dateToString().stringToDate() {
            let endDay = startDay.addingTimeInterval(86400)
            
            let data = realm.objects(MainList.self).where {
                $0.date >= startDay && $0.date < endDay && $0.group == group
            }
            
            return data.sorted(byKeyPath: "isDone")
        } else {
            return nil
        }
    }
    
    func fetchFilterOneDay(date: Date) -> Results<MainList>? {
        if let startDay = date.dateToString().stringToDate() {
            let endDay = startDay.addingTimeInterval(86400)
            
            let data = realm.objects(MainList.self).where {
                $0.date >= startDay && $0.date < endDay
            }
            
            return data.sorted(byKeyPath: "isDone")
        } else {
            return nil
        }
    }
    
    func fetchFilterWithID(isTodo: Bool = true, id: ObjectId) -> Results<MainList> {
        let data = realm.objects(MainList.self).where {
            $0._id == id
        }
        return data
    }
    
    func create(_ item: MainList) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func update(id: ObjectId, contents: String, date: Date, group: ObjectId) {
        do {
            try realm.write {
                realm.create(MainList.self, value: ["_id": id, "contents": contents, "date": date, "group": group], update: .modified)
            }
        } catch {
            print(error) //nslog로 기록 남기기, 집계하기 등 필요
        }
    }
    
    func fetchGroup(group: ObjectId) -> Results<MainList> {
        let data = realm.objects(MainList.self).where {
            $0.group == group
        }
        return data
    }
    
    func toggleDone(id: ObjectId, isDone: Bool) {
        do {
            try realm.write {
                realm.create(MainList.self, value: ["_id": id, "isDone": isDone], update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func delete(_ item: MainList) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}
