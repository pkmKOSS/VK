// Friend.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// Друг
final class Friend: Object, Decodable {
    /// ID друга
    @objc dynamic var id: Int
    /// Город проживания
    @objc dynamic var city: City?
    /// url-строка аватара
    @objc dynamic var photo: String?
    /// Имя и фамилия
    @objc dynamic var firstName, lastName: String

    /// Ключи
    enum CodingKeys: String, CodingKey {
        case id, city
        case photo = "photo_200_orig"
        case firstName = "first_name"
        case lastName = "last_name"
    }

    override class func primaryKey() -> String? {
        "id"
    }
}
