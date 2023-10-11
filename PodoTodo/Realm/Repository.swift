//
//  Repository.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/07.
//

import Foundation
import RealmSwift

protocol RepositoryType: AnyObject {
    func fetch() -> Results<MainList>
    func fetchFilter(isTodo: Bool, date: Date) -> Results<MainList>
    func create(_ item: MainList)
    func update(id: ObjectId, contents: String, date: Date)
    func delete(_ item: MainList)
}

class Repository: RepositoryType {
    
    static let shared = Repository()
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
    
    //전체 데이터 가져오기(read)
    func fetch() -> Results<MainList> {
        let data = realm.objects(MainList.self)
        return data
    }
    
    
    func fetchFilter1(isTodo: Bool) -> Results<MainList> {

        let data = realm.objects(MainList.self).where {

            $0.isTodo == isTodo
        }
        let result = data.sorted(byKeyPath: "isDone")
        return result
    }
    
    
    func fetchFilter(isTodo: Bool, date: Date) -> Results<MainList> {
        let startDay = date.dateToString().stringToDate()!
        let endDay = startDay.addingTimeInterval(86400)
        
        let data = realm.objects(MainList.self).filter("date >= %@ AND date < %@", startDay, endDay)
        
//        let result = data.where {
//            $0.isTodo == isTodo
//        }.sorted(byKeyPath: "isDone")
        
        
        return data.sorted(byKeyPath: "isDone")
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
    
    func update(id: ObjectId, contents: String, date: Date) {
        do {
            try realm.write {
                realm.create(MainList.self, value: ["_id": id, "contents": contents, "date": date], update: .modified)
            }
        } catch {
            print(error) //nslog로 기록 남기기, 집계하기 등 필요
        }
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
