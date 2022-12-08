// TextCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с текстом поста.
final class TextCell: UITableViewCell, NewsPostsCellProtocol {
    // MARK: - Private @IBOutlet

    @IBOutlet var postTextView: UITextView!

    // MARK: Public methods

    func configureCell(post: NewsPostItem, group: NetworkUnit) {
        postTextView.text = post.text
    }
}
