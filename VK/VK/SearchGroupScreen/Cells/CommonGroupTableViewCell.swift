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
    private var networkService = NetworkService()

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
            self.networkService.fetchPhoto(isCachingEnable: true, by: avatarImageName) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: data) else { return }
                        self.groupAvatarImageView.image = image
                    }
                case let .failure(error):
                    print(error)
                }
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
