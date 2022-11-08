// CommonGroupTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Общая ячейка для списка сообществ пользователя и поиска сооществ.
final class CommonGroupTableViewCell: UITableViewCell {
    // MARK: - private outlats

    @IBOutlet private var groupAvatarImageView: UIImageView!
    @IBOutlet private var groupNameLabel: UILabel!
    @IBOutlet private var groupDescriptionLabel: UILabel!

    // MARK: - Private properties

    private var friend: NetworkUnit?
    private var tapHandler: TapHandler?

    // MARK: - Public methods

    func configureCell(unit: NetworkUnit, tapHandler: TapHandler? = nil) {
        self.tapHandler = tapHandler
        friend = unit
        configreAvatarImageView(avatarImageName: unit.avatarImageName)
        configureNameLabel(nameText: unit.name)
        configureDescriptionLabel(nameText: unit.description)
        addTapGestoreRecognizer()
    }

    // MARK: - Private methods

    private func configreAvatarImageView(avatarImageName: String) {
        groupAvatarImageView.image = UIImage(named: avatarImageName)
    }

    private func configureNameLabel(nameText: String) {
        groupNameLabel.text = nameText
    }

    private func configureDescriptionLabel(nameText: String) {
        groupDescriptionLabel.text = nameText
    }

    private func addTapGestoreRecognizer() {
        guard tapHandler != nil else { return }
        let gesotreRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(gesotreRecognizer)
    }

    @objc private func tapAction() {
        guard
            let action = tapHandler,
            let friend = friend
        else {
            return
        }
        action(friend)
    }
}
