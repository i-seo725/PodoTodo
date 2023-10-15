//
//  GroupRepository.swift
//  PodoTodo
//
//  Created by 이은서 on 2023/10/15.
//

import Foundation
import RealmSwift

class GroupRepository {
    
    static let shared = GroupRepository()
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
    
    func fetch() -> Results<GroupList> {
        let data = realm.objects(GroupList.self)
        return data
    }
    
    func fetchFilter(id: ObjectId) -> Results<GroupList> {
        let data = realm.objects(GroupList.self).where {
            $0._id == id
        }
        return data
    }
    
    func create(_ item: GroupList) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func update(id: ObjectId, groupName: String, color: String?) {
        do {
            try realm.write {
                realm.create(GroupList.self, value: ["_id": id, "groupName": groupName, "color": color], update: .modified)
            }
        } catch {
            print(error) //nslog로 기록 남기기, 집계하기 등 필요
        }
    }
    
    func delete(_ item: GroupList) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}
