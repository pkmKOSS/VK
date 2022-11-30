// FriendsResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Друзья
final class FriendsResponse: Decodable {
    let response: Friends

    /// Ответ с количеством друзей и объектами "Друг"
    class Friends: Decodable {
        let count: Int
        let items: [Friend]
    }
}
