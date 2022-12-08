// UsersReactionsCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с реакцией пользователей на пост.
final class UsersReactionsCell: UITableViewCell, NewsPostsCellProtocol {
    // MARK: - Private @IBOutlet

    @IBOutlet private var likesCountLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var repostsCountLabel: UILabel!
    @IBOutlet private var commentsCountLabel: UILabel!

    // MARK: - Public methods

    func configureCell(post: NewsPostItem, group: NetworkUnit, networkService: NetworkService? = nil) {
        likesCountLabel.text = String(post.likes.count)
        repostsCountLabel.text = String(post.reposts.count)
        commentsCountLabel.text = String(post.comments.count)
    }
}
