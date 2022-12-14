// SaveDataOperation.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Операция сохранения данных.
final class SaveDataOperation: Operation {
    // MARK: - Private properties

    private let operation: FetchFriendsAsyncOperation
    private let dataBaseService: DataBaseService

    // MARK: - Конструктор

    /// Конструктор
    /// - Parameters:
    ///   - dataForSave: Данные для сохранения
    ///   - dataBaseService: Сервис для сохранения
    init(dataBaseService: DataBaseService, operation: FetchFriendsAsyncOperation) {
        self.dataBaseService = dataBaseService
        self.operation = operation
        super.init()
    }

    // MARK: - Public methods

    override func main() {
        guard let data = operation.resultOfRequest?.response.items else { return }
        dataBaseService.saveData(objects: data)
    }
}
