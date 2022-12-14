// NetworkServicable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import PromiseKit

/// Протокол для запросов API Вконтакте
protocol NetworkServicable {
    func getAuthPageRequest() -> URL?
    func fetchFriends(completion: @escaping (Swift.Result<FriendsResponse, Error>) -> ())
    func fetchClientsGroups() -> Promise<[Group]>?
    func fetchAllPhoto(by id: Int, completion: @escaping (Swift.Result<PhotoResponse, Error>) -> ())
    func fetchPhoto(
        isCachingEnable: Bool,
        by urlString: String,
        completion: @escaping (Swift.Result<Data, Error>) -> ()
    )
    func fetchFoundGroups(
        parametrsMap: [String: String],
        completion: @escaping (Swift.Result<GroupsResponse, Error>) -> ()
    )
    func fetchPosts(by id: Int, completion: @escaping (Swift.Result<NewsPostResponse, Error>) -> ())
}
