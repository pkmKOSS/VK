// NetworkServicable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для запросов API Вконтакте
protocol NetworkServicable {
    func getAuthPageRequest() -> URL?
    func fetchFriends(complition: @escaping (Decodable) -> ())
    func fetchClientsGroups(complition: @escaping (ResponseWithGroups) -> ())
    func fetchAllPhoto(by id: Int, complition: @escaping (Decodable) -> ())
    func fetchPhoto(by urlString: String, completion: @escaping (Data) -> ())
    func fetchFoundGroups(parametrsMap: [String: String], complition: @escaping (ResponseWithGroups) -> ())
}
