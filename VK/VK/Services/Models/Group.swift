// Group.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// Группа
final class Group: Object, Decodable {
    /// ID группы
    @objc dynamic var id = 0
    /// Полное и краткое имя
    @objc dynamic var name = "", screenName = ""
    /// Описание группы
    @objc dynamic var groupdDescription: String?
    /// Аватар группы
    @objc dynamic var photo200: String = ""
    /// Тип сообщества
    var type: TypeEnum = .group

    override class func primaryKey() -> String? {
        "id"
    }

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
