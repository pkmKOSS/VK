// Session.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описывает текущую сессию, содержит синглотон.
final class Session {
    // MARK: - singlton

    static let shared = Session()

    // MARK: - Public properties

    var userID: Int?
    var accessToken: String?

    // MARK: - Private init

    private init() {}
}
