// GroupsResponse.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift

/// Ответ с группами и их количеством.
struct GroupsResponse: Decodable {
    let response: Response

    /// Ответ с группами  и их количеством
    struct Response: Decodable {
        let count: Int
        let items: [Group]
    }
}
