//
//  GrapeRepository.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/20.
//

import Foundation
import RealmSwift

final class GrapeRepository {
    
    private let realm = try! Realm()
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: ", version)
        } catch {
            print(error)
        }
    }
    
    func fetch() -> Results<GrapeList> {
        let data = realm.objects(GrapeList.self)
        return data
    }
    
    func fetchCurrent() -> Results<GrapeList> {
        let data = realm.objects(GrapeList.self).where {
            $0.isCurrent == true
        }
        return data
    }
    
    func fetchTodayDone() -> Results<GrapeList> {
        let today: Date? = Date().dateToString().stringToDate()
        let data = realm.objects(GrapeList.self).where {
            $0.completeDate == today
        }
        return data
    }
    
    func create(_ item: GrapeList) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func update(id: ObjectId, isCurrent: Bool, fillCount: Int, completeDate: Date?, plusDate: Date?, deleteDate: Date?) {
        do {
            try realm.write {
                realm.create(GrapeList.self, value: ["_id": id, "isCurrent": isCurrent, "fillCount": fillCount, "completeDate": completeDate, "plusDate": plusDate, "deleteDate": deleteDate], update: .modified)
            }
        } catch {
            print(error) //nslog로 기록 남기기, 집계하기 등 필요
        }
    }
    
    func delete(_ item: GrapeList) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}
