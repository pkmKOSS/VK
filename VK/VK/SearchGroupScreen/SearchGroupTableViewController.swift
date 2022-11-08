// SearchGroupTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран поиска сообществ.
final class SearchGroupTableViewController: UITableViewController {
    // MARK: - Public properties

    var groups: [NetworkUnit] = []

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        makeGroups()
        regCells()
    }

    // MARK: - Public methods

    // MARK: - UITableViewDelegates

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didRequestUnwind()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: CellIdentifiers.commonGroupTableViewCellID,
                for: indexPath
            ) as? CommonGroupTableViewCell
        else { return UITableViewCell() }
        cell.configureCell(unit: groups[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    // MARK: - Private methods

    private func regCells() {
        tableView.register(
            UINib(nibName: CellIdentifiers.commonGroupTableViewCellID, bundle: nil),
            forCellReuseIdentifier: CellIdentifiers.commonGroupTableViewCellID
        )
    }

    private func makeGroups() {
        var indexCounter = 0
        for group in GroupsNames.groupsNames {
            groups.append(NetworkUnit(
                name: group,
                description: GroupsDescriptions.groupsDescriptions[safe: indexCounter] ?? "",
                avatarImageName: GroupsAvatarImageNames.groupsAvatarImageNames[safe: indexCounter] ?? "",
                unitImageNames: GroupsAvatarImageNames.groupsAvatarImageNames
            ))
            indexCounter += 1
        }
    }

    private func didRequestUnwind() {
        performSegue(withIdentifier: SegueIdentifiers.addGroupID, sender: nil)
    }
}
