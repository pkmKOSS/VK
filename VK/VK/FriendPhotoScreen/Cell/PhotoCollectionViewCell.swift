// PhotoCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка экрана с фотографиями пользователя
final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private @IBOutlets
    
    @IBOutlet private var firstPhotoImageView: UIImageView!
    @IBOutlet private var secondPhotoImageView: UIImageView!
    @IBOutlet private var thirdPhotoImageView: UIImageView!
    @IBOutlet private var foursPhotoImageView: UIImageView!
    
    // MARK: Public methods
    
    /// Конфигурирует ячейку
    /// - Parameter unit: Экземпляр пользователя или сообщества.
    func configureCell(unit: NetworkUnit) {
        configreAvatarImageView(imageNames: unit.unitImageNames ?? [])
    }
    
    // MARK: Private methods
    
    private func configreAvatarImageView(imageNames: [String]) {
        firstPhotoImageView.image = UIImage(named: imageNames[safe: 0] ?? "")
        secondPhotoImageView.image = UIImage(named: imageNames[safe: 1] ?? "")
        thirdPhotoImageView.image = UIImage(named: imageNames[safe: 2] ?? "")
        foursPhotoImageView.image = UIImage(named: imageNames[safe: 3] ?? "")
    }
}
