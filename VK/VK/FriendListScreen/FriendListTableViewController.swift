// FriendListTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

typealias TapHandler = (NetworkUnit) -> ()

/// Экран со списком друзей.
final class FriendListTableViewController: UITableViewController {
    // MARK: - Private properties

    private var users: [NetworkUnit] = []
    private var selectedFriend: NetworkUnit?
    private var tapHandler: TapHandler?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == SegueIdentifiers.showFriendSegue,
            let destination = segue.destination as? FriendPhotoCollectionViewController,
            let friend = selectedFriend
        else { return }
        destination.friend = friend
    }

    // MARK: - Public methods

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.commonGroupTableViewCellID,
                for: indexPath
            ) as? CommonGroupTableViewCell else { return UITableViewCell() }
        cell.configureCell(unit: users[indexPath.row], tapHandler: tapHandler)
        return cell
    }

    // MARK: - Private methods

    private func setupCell() {
        makeUsers()
        regCells()
        configreTapHandler()
    }

    private func regCells() {
        tableView.register(
            UINib(
                nibName: CellIdentifiers.commonGroupTableViewCellID,
                bundle: nil
            ),
            forCellReuseIdentifier: CellIdentifiers.commonGroupTableViewCellID
        )
    }

    private func configreTapHandler() {
        tapHandler = { [weak self] user in
            guard let self = self else { return }
            self.selectedFriend = user
            self.performSegue(withIdentifier: SegueIdentifiers.showFriendSegue, sender: nil)
        }
    }

    private func makeUsers() {
        var indexCounter = 0
        for user in UserNames.names {
            users.append(NetworkUnit(
                name: user,
                description: UserLocations.locations[safe: indexCounter] ?? "",
                avatarImageName: UserAvatarImageNames.avatarImageNames[safe: indexCounter] ?? "",
                unitImageNames: UserAvatarImageNames.avatarImageNames
            ))
            indexCounter += 1
        }
    }
}
