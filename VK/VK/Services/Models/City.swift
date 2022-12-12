// City.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// Место проживания
final class City: Object, Decodable {
    /// ID города
    @objc dynamic var id: Int
    /// Название города
    @objc dynamic var title: String

    override class func primaryKey() -> String? {
        "id"
    }
}
