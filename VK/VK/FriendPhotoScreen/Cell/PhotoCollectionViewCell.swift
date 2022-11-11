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

    // MARK: - Private properties

    private var tapHandler: TapHandler?
    private var selectedFriend: NetworkUnit?

    // MARK: Public methods

    func configureCell(unit: NetworkUnit, handler: TapHandler?) {
        tapHandler = handler
        selectedFriend = unit
        configureTapGestoreRecognizer()
        configreAvatarImageView(imageNames: unit.unitImageNames ?? [])
    }

    // MARK: Private methods

    private func configreAvatarImageView(imageNames: [String]) {
        firstPhotoImageView.image = UIImage(named: imageNames[safe: 0] ?? "")
        secondPhotoImageView.image = UIImage(named: imageNames[safe: 1] ?? "")
        thirdPhotoImageView.image = UIImage(named: imageNames[safe: 2] ?? "")
        foursPhotoImageView.image = UIImage(named: imageNames[safe: 3] ?? "")
    }

    private func configureTapGestoreRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandlerAction))
        firstPhotoImageView.addGestureRecognizer(recognizer)
        firstPhotoImageView.isUserInteractionEnabled = true
    }

    @objc private func tapHandlerAction() {
        guard
            let action = tapHandler,
            let unit = selectedFriend
        else { return }
        action(unit)
    }
}
