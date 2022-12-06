// FriendsResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Друзья
final class FriendsResponse: Decodable {
    /// Ответ
    let response: Friends

    /// Ответ с количеством друзей и объектами "Друг"
    class Friends: Decodable {
        /// Количество друзей
        let count: Int
        /// Массив друзей
        let items: [Friend]
    }
}
