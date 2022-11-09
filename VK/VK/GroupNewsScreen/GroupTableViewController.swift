// GroupTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран с новостями сообщества.
final class GroupNewsTableViewController: UITableViewController {
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewTableViewCell", bundle: nil), forCellReuseIdentifier: "NewTableViewCell")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell") as? NewTableViewCell
        else { return UITableViewCell() }
        return cell
    }
}
