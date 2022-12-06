// PhotoItems.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Фото
final class PhotoItems: Decodable {
    /// Размеры фото
    let sizes: [Size]

    enum CodingKeys: String, CodingKey {
        case sizes
    }
}
