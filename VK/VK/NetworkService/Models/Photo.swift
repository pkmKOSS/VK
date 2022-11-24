// Photo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ответ с фотографиями
struct ResponseWithPhoto: Codable {
    let response: Response

    // MARK: - Response

    struct Response: Codable {
        let count: Int
        let items: [Photo]
    }

    // MARK: - Item

    final class Photo: Codable {
        let sizes: [Size]

        enum CodingKeys: String, CodingKey {
            case sizes
        }
    }

    // MARK: - Size

    struct Size: Codable {
        let height: Int
        let type: String
        let width: Int
        let url: String
    }
}
