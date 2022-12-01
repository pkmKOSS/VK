// PhotoItems.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

// MARK: - Item

final class PhotoItems: Decodable {
    let sizes: [Size]

    enum CodingKeys: String, CodingKey {
        case sizes
    }
}
