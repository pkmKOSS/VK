// Session.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описывает текущую сессию, содержит синглотон.
final class Session {
    // MARK: - singlton

    static let shared = Session()

    // MARK: - Public properties

    var accessToken: String? {
        didSet {
            NetworkService.shared.token = accessToken
        }
    }

    // MARK: - Private init

    private init() {}
}
