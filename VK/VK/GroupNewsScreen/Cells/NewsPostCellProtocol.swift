// NewsPostCellProtocol.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

typealias NewsPostCell = UITableViewCell & NewsPostsCellProtocol

/// Настройки ячейки поста.
protocol NewsPostsCellProtocol {
    func configureCell(post: NewsPostItem, group: NetworkUnit)
}
