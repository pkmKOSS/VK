// Photo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Фото
struct Photo: Decodable {
    /// Размеры фото
    let sizes: [Size]
    /// Текстоовое описание фото
    let text: String
}
