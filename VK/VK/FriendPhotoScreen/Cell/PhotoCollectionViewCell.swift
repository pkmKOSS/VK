// PhotoCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка экрана с фотографиями пользователя
final class PhotoCollectionViewCell: UICollectionViewCell {
    private struct Constants {
        static let ownerIDName = "owner_id"
        static let modeParamName = "extended"
        static let modeParamValue = "1"
        static let defaultFriendID = 1
    }

    // MARK: - Private @IBOutlets

    @IBOutlet private var firstPhotoImageView: UIImageView!
    @IBOutlet private var secondPhotoImageView: UIImageView!
    @IBOutlet private var thirdPhotoImageView: UIImageView!
    @IBOutlet private var foursPhotoImageView: UIImageView!

    // MARK: - Private properties

    private var tapHandler: TapHandler?
    private var selectedFriend: NetworkUnit?
    private var imagesURLStrings: [String] = []
    private var images: [UIImage] = []

    // MARK: Public methods

    func configureCell(unit: NetworkUnit, handler: TapHandler?) {
        selectedFriend = unit
        fetchPhotos()
        tapHandler = handler
        configureTapGestoreRecognizer()
    }

    // MARK: Private methods

    private func configreAvatarImageView() {
        for imagesURLString in imagesURLStrings {
            NetworkService.shared.fetchPhoto(by: imagesURLString) { [weak self] data in
                guard let self = self else { return }
                self.images.append(UIImage(data: data) ?? UIImage())
                if self.images.count == self.imagesURLStrings.count {
                    DispatchQueue.main.async {
                        self.configurePhotos()
                    }
                }
            }
        }
    }

    private func configurePhotos() {
        firstPhotoImageView.image = images.randomElement() ?? UIImage()
        secondPhotoImageView.image = images.randomElement() ?? UIImage()
        thirdPhotoImageView.image = images.randomElement() ?? UIImage()
        foursPhotoImageView.image = images.randomElement() ?? UIImage()
    }

    private func configureTapGestoreRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandlerAction))
        firstPhotoImageView.addGestureRecognizer(recognizer)
        firstPhotoImageView.isUserInteractionEnabled = true
    }

    private func fetchPhotos() {
        NetworkService.shared.fetchAllPhoto(by: selectedFriend?.id ?? Constants.defaultFriendID) { result in
            let resultWithPhotos = result as? ResponseWithPhoto

            for photo in resultWithPhotos?.response.items ?? [] {
                let size = photo.sizes
                size.forEach { [weak self] item in
                    guard let self = self else { return }
                    self.imagesURLStrings.append(item.url)
                }
            }
            self.configreAvatarImageView()
        }
    }

    @objc private func tapHandlerAction() {
        guard
            let action = tapHandler,
            let unit = selectedFriend
        else { return }
        action(unit)
    }
}
