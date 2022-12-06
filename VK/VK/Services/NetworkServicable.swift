// NetworkServicable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для запросов API Вконтакте
protocol NetworkServicable {
    func getAuthPageRequest() -> URL?
    func fetchFriends(complition: @escaping (Result<FriendsResponse, Error>) -> ())
    func fetchClientsGroups(complition: @escaping (Result<GroupsResponse, Error>) -> ())
    func fetchAllPhoto(by id: Int, complition: @escaping (Result<PhotoResponse, Error>) -> ())
    func fetchPhoto(by urlString: String, completion: @escaping (Result<Data, Error>) -> ())
    func fetchFoundGroups(parametrsMap: [String: String], complition: @escaping (Result<GroupsResponse, Error>) -> ())
    func fetchPosts(by id: Int, complition: @escaping (Result<NewsPostResponse, Error>) -> ())
}
