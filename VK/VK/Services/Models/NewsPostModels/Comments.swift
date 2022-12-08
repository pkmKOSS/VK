// Comments.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Комментарии
struct Comments: Decodable {
    /// Количество комментариев
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}
