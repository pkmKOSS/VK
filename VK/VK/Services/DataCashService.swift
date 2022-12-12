// DataCashService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Сервис для кэширования данных.
final class DataCashService {
    // MARK: - Public enum

    /// Типы данных конвертируемых  Data
    enum CashDataType: String {
        case images = "Images"
    }

    // MARK: - Private constants

    private enum Constants {
        static let slashName = "/"
    }

    // MARK: - Private properties

    private var cashStorageMap: [String: Data] = [:]

    // MARK: - Public methods

    /// Сохранение данных в кеш.
    /// - Parameters:
    ///   - fileURL: URL объекта. Используется для присвоения имени локальному файлу.
    ///   - data: Экземпляр Data
    ///   - cashDataType: Тип, который был источником Data. Влияет на директорию размещения файла.
    func saveDataToCache(fileURL: String, data: Data, cashDataType: CashDataType) {
        guard
            let path = getDirectoryPath(cashDataType: cashDataType),
            let fileName = fileURL.split(separator: Character(Constants.slashName)).last
        else { return }
        let filePath = "\(path)/\(fileName)"
        FileManager.default.createFile(atPath: filePath, contents: data)
        cashStorageMap[String(fileName)] = data
    }

    /// Загрузка данных из кеша.
    /// - Parameters:
    ///   - fileURL: URL объекта. Используется для поиска файла.
    ///   - cashDataType: Тип, который был источником Data. Влияет на директорию размещения файла.
    ///   - completion: Возвращает экземпляр класса Result<Data, Swift.Error>).
    func loadDataFromCache(
        fileURL: String,
        cashDataType: CashDataType,
        completion: @escaping (Swift.Result<Data, Swift.Error>) -> ()
    ) {
        guard
            let directoryPath = getDirectoryPath(cashDataType: cashDataType),
            let fileName = fileURL.split(separator: Character(Constants.slashName)).last
        else { return }
        let url = URL(fileURLWithPath: "\(directoryPath)\(Constants.slashName)\(fileName)")

        if let cashedData = cashStorageMap[String(fileName)] {
            completion(.success(cashedData))
        } else {
            let url = URL(fileURLWithPath: "\(directoryPath)/\(fileName)")

            do {
                let data = try Data(contentsOf: url)
                completion(.success(data))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private methods

    private func getDirectoryPath(cashDataType: CashDataType) -> String? {
        let directory = {
            switch cashDataType {
            case .images:
                return FileManager.SearchPathDirectory.cachesDirectory
            }
        }()

        guard
            let cashDirectory = FileManager.default.urls(for: directory, in: .userDomainMask).first
        else { return nil }
        let url = cashDirectory.appendingPathComponent(cashDataType.rawValue, isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }

        return cashDirectory.appendingPathComponent(cashDataType.rawValue, isDirectory: true).path
    }
}
