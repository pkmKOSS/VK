// ImageCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с изображением поста.
final class ImageCell: NewsPostCell {
    // MARK: - Private constants

    private struct Constants {
        static let sizeTypeName = "r"
    }

    // MARK: - Private @IBOutlet

    @IBOutlet private var postsImageView: UIImageView!

    // MARK: - Public methods

    func configureCell(post: NewsPostItem, group: NetworkUnit, networkService: NetworkService? = nil) {
        guard
            let photo = post.attachments?.first?.photo,
            let size = selectImageSize(sizes: photo.sizes).first,
            let networkService = networkService
        else { return }
        postsImageView.loadImageFromURL(urlString: size.url, networkService: networkService)
    }

    // MARK: - Private methods

    private func selectImageSize(sizes: [Size]) -> [Size] {
        let largeSizes = sizes.filter { size in
            size.type == Constants.sizeTypeName
        }
        return largeSizes
    }
}
