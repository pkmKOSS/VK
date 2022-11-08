// SearchGroupTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран поиска сообществ.
final class SearchGroupTableViewController: UITableViewController {
    
    // MARK: - Public properties
    
    var groups: [Group] = []
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGroups()
        tableView.register(
            UINib(nibName: CellIdentifiers.commonGroupTableViewCellID, bundle: nil),
            forCellReuseIdentifier: CellIdentifiers.commonGroupTableViewCellID
        )
    }
    
    // MARK: - Private methods
    
    private func makeGroups() {
        var indexCounter = 0
        for group in GroupsNames.groupsNames {
            groups.append(Group(
                name: group,
                description: GroupsDescriptions.groupsDescriptions[safe: indexCounter] ?? "",
                avatarImageName: GroupsAvatarImageNames.groupsAvatarImageNames[safe: indexCounter] ?? ""
            ))
            indexCounter += 1
        }
    }
    
    private func didRequestUnwind() {
        performSegue(withIdentifier: SegueIdentifiers.addGroupID, sender: nil)
    }
    
    // MARK: - delegates methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didRequestUnwind()
    }
    
    // MARK: - datasource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
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
}
