// Size.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описание изображения.
struct Size: Decodable {
    /// Высота
    let height: Int
    /// Тип
    let type: String
    /// Ширина
    let width: Int
    /// Ссылка на изображение
    let url: String
}
