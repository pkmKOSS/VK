// MyGroupsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран c подписками на группы.
final class MyGroupsTableViewController: UITableViewController {
    // MARK: - Private constants

    private struct Constants {
        static let fieldsValue = "description"
        static let fieldsName = "fields"
        static let groupdsDescripnionModeName = "extended"
        static let groupdsDescripnionModeValue = "1"
    }

    // MARK: - Private properties

    private var groups: [NetworkUnit] = []
    private var selectedGroup: NetworkUnit?
    private var tapHandler: TapHandler?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMyGroupes()
        configureTapHandler()
        regCells()
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == SegueIdentifiers.groupNewsScreenText,
            let destination = segue.destination as? GroupNewsTableViewController,
            let group = selectedGroup
        else { return }
        destination.group = group
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: CellIdentifiers.commonGroupTableViewCellID,
                for: indexPath
            ) as? CommonGroupTableViewCell
        else { return UITableViewCell() }
        cell.configureCell(unit: groups[indexPath.row], labelNameTapHandler: tapHandler)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    // MARK: Private IBAction

    @IBAction private func addGroupAction(segue: UIStoryboardSegue) {
        guard
            segue.identifier == SegueIdentifiers.addGroupText,
            let myGroupsTableViewController = segue.source as? SearchGroupTableViewController,
            let indexPath = myGroupsTableViewController.tableView.indexPathForSelectedRow
        else { return }
        let group = myGroupsTableViewController.groups[indexPath.row]
        groups.append(group)
        tableView.reloadData()
    }

    // MARK: Private methods

    private func fetchMyGroupes() {
        NetworkServiceble.shared.fetchClientsGroups(
            parametersMap: [
                Constants.groupdsDescripnionModeName: Constants.groupdsDescripnionModeValue,
                Constants.fieldsName: Constants.fieldsValue
            ]
        ) { groups in
            let array = groups.response.items.map { group in
                NetworkUnit(
                    name: group.name,
                    description: group.groupdDescription ?? "",
                    avatarImageName: group.photo200,
                    unitImageNames: [],
                    id: group.id
                )
            }
            self.groups = array
            self.tableView.reloadData()
        }
    }

    private func regCells() {
        tableView.register(
            UINib(nibName: CellIdentifiers.commonGroupTableViewCellID, bundle: nil),
            forCellReuseIdentifier: CellIdentifiers.commonGroupTableViewCellID
        )
    }

    private func configureTapHandler() {
        tapHandler = { [weak self] group in
            guard let self = self else { return }
            self.selectedGroup = group
            self.performSegue(withIdentifier: SegueIdentifiers.groupNewsScreenText, sender: nil)
        }
    }
}
