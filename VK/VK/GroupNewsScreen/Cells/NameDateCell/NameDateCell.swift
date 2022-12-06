// NameDateCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с именем автора и датой поста.
class NameDateCell: UITableViewCell, NewsPostsCellProtocol {
    @IBOutlet var postAuthorNameLabel: UILabel!
    @IBOutlet var postsDateNameLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(post: NewsPostItem, group: NetworkUnit) {
        postAuthorNameLabel.text = group.name
        postsDateNameLabel.text = formateDate(date: post.date)
    }

    func formateDate(date: Int) -> String {
        let dateInterval = TimeInterval(date)
        let date = Date(timeIntervalSince1970: dateInterval)
        let dateFormater = DateFormatter()
        let dateFormate = "dd-MM-yyyy hh:mm"
        dateFormater.dateFormat = dateFormate
        return dateFormater.string(from: date)
    }
}
