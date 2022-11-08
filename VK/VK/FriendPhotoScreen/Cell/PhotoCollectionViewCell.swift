// PhotoCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка экрана с фотографиями пользователя
final class PhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - Private @IBOutlets

    @IBOutlet private var photoOne: UIImageView!
    @IBOutlet private var photoTwo: UIImageView!
    @IBOutlet private var photoThree: UIImageView!
    @IBOutlet private var photoFour: UIImageView!

    // MARK: Public methods

    /// Конфигурирует ячейку
    /// - Parameter unit: Экземпляр пользователя или сообщества.
    func configureCell(unit: NetworkUnit) {
        configreAvatarImageView(imageNames: unit.unitImageNames ?? [])
    }

    // MARK: Private methods

    private func configreAvatarImageView(imageNames: [String]) {
        photoOne.image = UIImage(named: imageNames[safe: 0] ?? "")
        photoTwo.image = UIImage(named: imageNames[safe: 1] ?? "")
        photoThree.image = UIImage(named: imageNames[safe: 2] ?? "")
        photoFour.image = UIImage(named: imageNames[safe: 3] ?? "")
    }
}
