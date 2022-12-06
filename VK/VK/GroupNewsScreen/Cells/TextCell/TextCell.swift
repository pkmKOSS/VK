// TextCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с текстом поста.
class TextCell: UITableViewCell, NewsPostsCellProtocol {
    @IBOutlet var postTextView: UITextView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(post: NewsPostItem, group: NetworkUnit) {
        postTextView.text = post.text
    }
}
