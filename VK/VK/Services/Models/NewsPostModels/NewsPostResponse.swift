// NewsPostResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Новости
struct NewsPostResponse: Decodable {
    let response: Response
}

/// Ответ с новостями
struct Response: Decodable {
    let count: Int
    let items: [NewsPostItem]
    let groups: [Group]
}
