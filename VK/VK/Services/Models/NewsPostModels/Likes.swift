// Likes.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Лайки
struct Likes: Decodable {
    /// Количество лайков
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}
