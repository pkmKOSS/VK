// SaveDataOperation.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Операция сохранения данных.
final class SaveDataOperation: Operation {
    // MARK: - Private properties

    private let dataForSave: [Friend]?
    private let dataBaseService: DataBaseService

    // MARK: - Конструктор

    /// Конструктор
    /// - Parameters:
    ///   - dataForSave: Данные для сохранения
    ///   - dataBaseService: Сервис для сохранения
    init(dataForSave: [Friend], dataBaseService: DataBaseService) {
        self.dataForSave = dataForSave
        self.dataBaseService = dataBaseService
        super.init()
    }

    // MARK: - Public methods

    override func main() {
        guard let data = dataForSave else { return }
        dataBaseService.saveData(objects: data)
    }
}
