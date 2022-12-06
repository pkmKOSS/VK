// Photo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Фото
struct Photo: Decodable {
    let sizes: [Size]
    let text: String
}
