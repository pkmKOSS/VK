// NameDateCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с именем автора и датой поста.
final class NameDateCell: NewsPostCell {
    // MARK: - Private constants

    private struct Constants {
        static let dateFormateName = "dd-MM-yyyy hh:mm"
    }

    // MARK: - Private @IBOutlets

    @IBOutlet private var postAuthorNameLabel: UILabel!
    @IBOutlet private var postsDateNameLabel: UILabel!

    // MARK: - Public methods

    func configureCell(post: NewsPostItem, group: NetworkUnit) {
        postAuthorNameLabel.text = group.name
        postsDateNameLabel.text = formateDate(date: post.date)
    }

    // MARK: - Private methods

    private func formateDate(date: Int) -> String {
        let dateInterval = TimeInterval(date)
        let date = Date(timeIntervalSince1970: dateInterval)
        let dateFormater = DateFormatter()
        let dateFormate = Constants.dateFormateName
        dateFormater.dateFormat = dateFormate
        return dateFormater.string(from: date)
    }
}
