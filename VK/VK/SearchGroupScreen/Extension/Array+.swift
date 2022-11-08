// Array+.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

// Сабскрипт для безопасного обращения к элементу массива по индексу.
extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
