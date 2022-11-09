// NewTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с новостным постом.
final class NewTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private var groupNameLabel: UILabel!
    @IBOutlet private var postImageView: UIImageView!

    // MARK: - Public methods

    func configureCell(unit: NetworkUnit, labelNameTapHandler: TapHandler? = nil) {
        groupNameLabel.text = unit.name
        postImageView.image = UIImage(named: "\(unit.avatarImageName)")
    }
}
