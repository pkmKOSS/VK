// Session.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описывает текущую сессию, содержит синглотон.
final class Session {
    // MARK: - singlton

    static let shared = Session()

    // MARK: - Public properties

    var token: String?
    var userID: Int?

    // MARK: - Private init

    private init() {}
}
