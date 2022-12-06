// PhotoResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Ответ с фотографиями
struct PhotoResponse: Decodable {
    /// Ответ
    let response: Response

    // MARK: - Response

    struct Response: Decodable {
        /// Количество фото
        let count: Int
        /// Массив с фото
        let items: [PhotoItems]
    }
}
