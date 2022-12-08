// Reposts.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Репост поста
struct Reposts: Decodable {
    /// Количество репостов
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}
