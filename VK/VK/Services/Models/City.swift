// City.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import RealmSwift

/// Место проживания
final class City: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var title: String
}
