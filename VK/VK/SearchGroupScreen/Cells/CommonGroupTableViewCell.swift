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
    private var labelNameTapHandler: TapHandler?
    private var avatarTapHandler: TapHandler?

    // MARK: - Public methods

    func configureCell(unit: NetworkUnit, labelNameTapHandler: TapHandler? = nil) {
        self.labelNameTapHandler = labelNameTapHandler
        friend = unit
        configreAvatarImageView(avatarImageName: unit.avatarImageName)
        configureNameLabel(nameText: unit.name)
        configureDescriptionLabel(nameText: unit.description)
        configTapNameLabelHandler()
        configTapAvatarHandler()
    }

    // MARK: - Private methods

    private func configreAvatarImageView(avatarImageName: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: avatarImageName) else { return }
            let imageData = try? Data(contentsOf: url)
            let image = UIImage(data: imageData ?? Data())
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.groupAvatarImageView.image = image
            }
        }
    }

    private func configureNameLabel(nameText: String) {
        groupNameLabel.text = nameText
    }

    private func configureDescriptionLabel(nameText: String) {
        groupDescriptionLabel.text = nameText
    }

    private func configTapNameLabelHandler() {
        guard labelNameTapHandler != nil else { return }
        let gesotreRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        groupNameLabel.isUserInteractionEnabled = true
        groupNameLabel.addGestureRecognizer(gesotreRecognizer)
    }

    private func configTapAvatarHandler() {
        let gesotreRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapAction))
        groupAvatarImageView.isUserInteractionEnabled = true
        groupAvatarImageView.addGestureRecognizer(gesotreRecognizer)
    }

    @objc private func avatarTapAction() {
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 1.7,
            options: .curveEaseOut,
            animations: {
                self.groupAvatarImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 1,
                    delay: 0,
                    animations: {
                        self.groupAvatarImageView.transform = .identity
                    }
                )
            }
        )
    }

    @objc private func tapAction() {
        guard
            let action = labelNameTapHandler,
            let friend = friend
        else {
            return
        }
        action(friend)
    }
}
