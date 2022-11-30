// Groups.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift

/// Ответ с группами и их количеством.
struct ResponseWithGroups: Decodable {
    let response: Response

    /// Ответ с группами  и их количеством
    struct Response: Decodable {
        let count: Int
        let items: [Group]
    }
}

/// Группа
final class Group: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var name = "", screenName = ""
    @objc dynamic var groupdDescription: String?
    @objc dynamic var photo200: String = ""
    var type: TypeEnum = .group

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case type
        case photo200 = "photo_200"
        case groupdDescription
    }

    /// Типы
    enum TypeEnum: String, Decodable {
        case event
        case group
        case page
    }
}
