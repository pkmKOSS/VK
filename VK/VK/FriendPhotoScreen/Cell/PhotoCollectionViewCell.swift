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
    private var selectedFriendNetworkUnit: NetworkUnit?
    private var imagesURLStrings: [String] = []
    private var images: [UIImage] = []
    private var networkService = NetworkService()

    // MARK: Public methods

    func configureCell(unit: NetworkUnit, handler: TapHandler?) {
        selectedFriendNetworkUnit = unit
        fetchAllPhoto()
        tapHandler = handler
        configureTapGestoreRecognizer()
    }

    // MARK: Private methods

    private func configreAvatarImageView() {
        for imagesURLString in imagesURLStrings {
            networkService.fetchPhoto(by: imagesURLString) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    guard let image = UIImage(data: data) else { return }
                    self.images.append(image)

                    if self.images.count == self.imagesURLStrings.count {
                        DispatchQueue.main.async {
                            self.configurePhotos()
                        }
                    }

                case let .failure(error):
                    print(error)
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

    private func fetchAllPhoto() {
        networkService
            .fetchAllPhoto(by: selectedFriendNetworkUnit?.id ?? Constants.defaultFriendID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(photoResponse):
                    for photo in photoResponse.response.items {
                        let size = photo.sizes
                        size.forEach { [weak self] item in
                            guard let self = self else { return }
                            self.imagesURLStrings.append(item.url)
                        }
                    }
                    self.configreAvatarImageView()
                case let .failure(error):
                    print(error)
                }
            }
    }

    @objc private func tapHandlerAction() {
        guard
            let action = tapHandler,
            let unit = selectedFriendNetworkUnit
        else { return }
        action(unit)
    }
}
