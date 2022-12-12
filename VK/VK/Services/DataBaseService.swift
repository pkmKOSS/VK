// DataBaseService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import Realm
import RealmSwift

/// Сервис для локального хранения данных.
struct DataBaseService {
    // MARK: - Public Methods

    func observeChanges<T: Object>(
        type: T.Type,
        notToken: inout RLMNotificationToken,
        completion: @escaping (RealmCollectionChange<Results<T>>) -> ()
    ) {
        do {
            let realm = try Realm()
            let objects = realm.objects(type)
            notToken = objects.observe { changes in
                completion(changes)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func saveData<T: Object>(objects: [T]) {
        do {
            let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: false)
            let realm = try Realm(configuration: configuration)

            try realm.write {
                objects.forEach { realm.add($0, update: .modified) }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadData<T: Object>(objectType: T.Type) -> [T]? {
        do {
            let realm = try Realm()
            let objects = Array(realm.objects(objectType))
            return objects
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
