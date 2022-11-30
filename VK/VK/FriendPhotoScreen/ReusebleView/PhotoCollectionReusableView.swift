// PhotoCollectionReusableView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Футер таблицы
final class PhotoCollectionReusableView: UICollectionReusableView {
    // MARK: - Private IBOutlets

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var countOfLikesLabel: UILabel!
    @IBOutlet private var heartButton: UIButton!

    // MARK: - Private properties

    private var countOfLikes = 0
    private var isAvatarLiked = false

    // MARK: Private IBAction

    @IBAction private func heartButtonAction(_ sender: Any) {
        guard
            isAvatarLiked
        else {
            countOfLikes += 1
            heartButton.setImage(
                UIImage(systemName: StringConstants.likeButtonFillImageName),
                for: .normal
            )

            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [],
                animations: {
                    [
                        self.countOfLikesLabel.transform = CGAffineTransform(a: 0, b: 0, c: 0, d: 0, tx: 20, ty: -20),
                        self.countOfLikesLabel.text = "\(self.countOfLikes)"
                    ]
                },
                completion: { _ in
                    UIView.animate(
                        withDuration: 1,
                        delay: 0,
                        animations: {
                            self.countOfLikesLabel.transform = .identity
                        }
                    )
                }
            )
            isAvatarLiked = true
            return
        }
        countOfLikes -= 1
        countOfLikesLabel.text = "\(countOfLikes)"
        heartButton.setImage(
            UIImage(systemName: StringConstants.likeButtonImageName),
            for: .normal
        )
        isAvatarLiked = false
    }

    func configure(urlString: String) {
        NetworkService.shared.fetchPhoto(by: urlString) { [weak self] data in
            guard let self = self else { return }
            self.avatarImageView.image = UIImage(data: data) ?? UIImage()
        }
    }
}
