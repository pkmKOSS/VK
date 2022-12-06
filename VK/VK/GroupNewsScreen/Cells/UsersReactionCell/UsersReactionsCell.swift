// UsersReactionsCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с реакцией пользователей на пост.
class UsersReactionsCell: UITableViewCell, NewsPostsCellProtocol {
    @IBOutlet var likesCountLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var repostsCountLabel: UILabel!
    @IBOutlet var commentsCountLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(post: NewsPostItem, group: NetworkUnit) {
        likesCountLabel.text = String(post.likes.count)
        repostsCountLabel.text = String(post.reposts.count)
        commentsCountLabel.text = String(post.comments.count)
    }
}
