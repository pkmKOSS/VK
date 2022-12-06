// ImageCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с изображением поста.
final class ImageCell: UITableViewCell, NewsPostsCellProtocol {
    @IBOutlet var postsImageView: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(post: NewsPostItem, group: NetworkUnit) {
        guard
            let photo = post.attachments?.first?.photo,
            let size = selectImageSize(sizes: photo.sizes).first
        else { return }
        postsImageView.loadImageFromURL(urlString: size.url)
    }

    func selectImageSize(sizes: [Size]) -> [Size] {
        let largeSizes = sizes.filter { size in
            size.type == "r"
        }

        return largeSizes
    }
}
