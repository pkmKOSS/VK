// Session.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описывает текущую сессию.
final class Session {
    // MARK: - singlton

    static let shared = Session()

    // MARK: - Public properties

    var accessToken: String?

    // MARK: - Private init

    private init() {}
}
