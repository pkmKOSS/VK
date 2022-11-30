// PhotoResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ответ с фотографиями
struct PhotoResponse: Decodable {
    let response: Response

    // MARK: - Response

    struct Response: Decodable {
        let count: Int
        let items: [PhotoItems]
    }
}
