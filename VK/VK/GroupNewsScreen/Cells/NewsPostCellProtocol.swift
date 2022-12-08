// NewsPostCellProtocol.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

typealias NewsPostCell = UITableViewCell & NewsPostsCellProtocol

/// Настройка ячейки поста.
protocol NewsPostsCellProtocol {
    func configureCell(post: NewsPostItem, group: NetworkUnit)
}
