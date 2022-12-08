// NetworkServicable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для запросов API Вконтакте
protocol NetworkServicable {
    func getAuthPageRequest() -> URL?
    func fetchFriends(completion: @escaping (Result<FriendsResponse, Error>) -> ())
    func fetchClientsGroups(completion: @escaping (Result<GroupsResponse, Error>) -> ())
    func fetchAllPhoto(by id: Int, completion: @escaping (Result<PhotoResponse, Error>) -> ())
    func fetchPhoto(by urlString: String, completion: @escaping (Result<Data, Error>) -> ())
    func fetchFoundGroups(parametrsMap: [String: String], completion: @escaping (Result<GroupsResponse, Error>) -> ())
    func fetchPosts(by id: Int, completion: @escaping (Result<NewsPostResponse, Error>) -> ())
}
