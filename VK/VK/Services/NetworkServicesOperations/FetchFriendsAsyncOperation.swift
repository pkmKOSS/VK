// FetchFriendsAsyncOperation.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Асинхронная операция по загрузке списка друзей
final class FetchFriendsAsyncOperation: AsyncOperation {
    // MARK: - Public properties

    var resultOfRequest: Result<FriendsResponse, Error>?

    // MARK: - Private properties

    private let networkService: NetworkService

    /// Конструктор
    /// - Parameter networkService: Сервис для работы с сетью
    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init()
    }

    // MARK: - Public methods

    override func main() {
        networkService.fetchFriends { [weak self] result in
            guard let self = self else { return }
            self.resultOfRequest = result
            self.state = .finished
        }
    }
}
