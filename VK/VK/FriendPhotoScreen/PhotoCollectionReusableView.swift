// PhotoCollectionReusableView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Хидер коллекции с фотографиями друга.
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
            countOfLikesLabel.text = "\(countOfLikes)"
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
}
