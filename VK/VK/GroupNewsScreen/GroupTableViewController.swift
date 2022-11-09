// GroupTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран с новостями сообщества.
final class GroupNewsTableViewController: UITableViewController {
    // MARK: - Public properties

    var group: NetworkUnit?

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: CellIdentifiers.newTableViewCell, bundle: nil),
            forCellReuseIdentifier: CellIdentifiers.newTableViewCell
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: CellIdentifiers.newTableViewCell) as? NewTableViewCell
        else { return UITableViewCell() }
        guard let group = group else {
            return UITableViewCell()
        }
        cell.configureCell(unit: group)
        return cell
    }
}
