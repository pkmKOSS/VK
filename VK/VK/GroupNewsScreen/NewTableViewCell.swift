// NewTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с новостным постом.
final class NewTableViewCell: UITableViewCell {
    // MARK: - Private visual components

    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!

    // MARK: - Public methods

    func configureCell(unit: NetworkUnit, labelNameTapHandler: TapHandler? = nil) {
        groupNameLabel.text = unit.name
        postImageView.image = UIImage(named: "\(unit.avatarImageName)")
    }
}
