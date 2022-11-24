// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Сервис для работы с Вконтакте
protocol NetworkService {
    func getAuthPageRequest() -> URL?
    func fetchFriends(parametersMap: [String: String], complition: @escaping (Codable) -> ())
    func fetchClientsGroups(parametersMap: [String: String], complition: @escaping (ResponseWithGroups) -> ())
    func fetchAllPhoto(parametersMap: [String: String], complition: @escaping (Codable) -> ())
    func fetchPhoto(by urlString: String, complition: @escaping (Data) -> ())
    func fetchFoundGroups(parametrsMap: [String: String], complition: @escaping (ResponseWithGroups) -> ())
}
