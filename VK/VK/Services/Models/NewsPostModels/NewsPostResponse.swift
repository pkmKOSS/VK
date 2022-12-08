// NewsPostResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Новости
struct NewsPostResponse: Decodable {
    /// Ответ
    let response: Response
}

/// Ответ с новостями
struct Response: Decodable {
    /// Количество постов
    let count: Int
    /// Посты
    let items: [NewsPostItem]
    /// Группы
    let groups: [Group]
}
