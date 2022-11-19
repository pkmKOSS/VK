// ShowPhotoView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Представление - слайд для скролла фотка.
final class ShowPhotoView: UIView {
    // MARK: - Public @IBOutlet

    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!

    // MARK: - Public methods

    func configurePhotoImage(
        image: UIImage? = UIImage(),
        recognizer: UISwipeGestureRecognizer,
        isHiden: Bool
    ) {
        photoImageView.image = image
        photoImageView.addGestureRecognizer(recognizer)
        photoImageView.isHidden = isHiden
    }

    func configureImageAnimation(transform: CGAffineTransform) {
        photoImageView.transform = transform
    }
}
