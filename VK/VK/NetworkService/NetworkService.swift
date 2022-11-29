// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Авторизация и получение списка ID друзей Вконтакте.
protocol NetworkService {
    func getAuthPageRequest(queryItems: [URLQueryItem]) -> URL?
    func fetchFriendsID(method: String, queryItems: [URLQueryItem])
}
