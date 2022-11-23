// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Требование к сущности взаимодействующей с Вконтакте
protocol NetworkService {
    func getAuthPageRequest(queryItems: [URLQueryItem]) -> URL?
    func getInfoFor(method: String, queryItems: [URLQueryItem])
}
