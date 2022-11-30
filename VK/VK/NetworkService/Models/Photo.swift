// Photo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ответ с фотографиями
struct ResponseWithPhoto: Decodable {
    let response: Response

    // MARK: - Response

    struct Response: Decodable {
        let count: Int
        let items: [Photo]
    }

    // MARK: - Item

    final class Photo: Decodable {
        let sizes: [Size]

        enum CodingKeys: String, CodingKey {
            case sizes
        }
    }

    // MARK: - Size

    struct Size: Decodable {
        let height: Int
        let type: String
        let width: Int
        let url: String
    }
}
