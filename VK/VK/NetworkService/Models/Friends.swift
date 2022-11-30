// Friends.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// Друзья
final class ResponseWithFriends: Decodable {
    let response: Friends

    /// Ответ с количеством друзей и объектами "Друг"
    class Friends: Decodable {
        let count: Int
        let items: [Friend]
    }
}

/// Место проживания
final class City: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var title: String
}

/// Друг
final class Friend: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var city: City?
    @objc dynamic var photo: String?
    @objc dynamic var firstName, lastName: String

    /// Ключи
    enum CodingKeys: String, CodingKey {
        case id, city
        case photo = "photo_200_orig"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
