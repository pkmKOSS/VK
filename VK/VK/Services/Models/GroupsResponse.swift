// GroupsResponse.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift

/// Ответ с группами и их количеством.
struct GroupsResponse: Decodable {
    /// Ответ
    let response: Response

    /// Ответ с группами  и их количеством
    struct Response: Decodable {
        /// Количество групп пользователя
        let count: Int
        /// Массив с группами
        let items: [Group]
    }
}
