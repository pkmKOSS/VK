// Session.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описывает текущую сессию, содержит синглотон.
final class Session {
    // MARK: - singlton

    static let shared = Session()

    // MARK: - Public properties

    var userID: Int?
    var accessToken: String? {
        didSet {
            NetworkServiceble.shared.token = accessToken
        }
    }

    // MARK: - Private init

    private init() {}
}
