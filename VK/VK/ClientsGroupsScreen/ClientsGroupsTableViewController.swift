// ClientsGroupsTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import PromiseKit
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

    private let networkService = NetworkService()
    private let dataBaseService = DataBaseService()
    private var networkUnits: [NetworkUnit] = []
    private var groups: [Group] = []
    private var selectedGroup: NetworkUnit?
    private var tapHandler: TapHandler?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScene()
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == SegueIdentifiers.groupNewsScreenName,
            let destination = segue.destination as? GroupNewsTableViewController,
            let group = selectedGroup
        else { return }
        destination.group = group
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        networkUnits.count
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            networkUnits.remove(at: indexPath.row)
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
        cell.configureCell(unit: networkUnits[indexPath.row], labelNameTapHandler: tapHandler)
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
        networkUnits.append(group)
        tableView.reloadData()
    }

    // MARK: Private methods

    private func configureScene() {
        fetchClientsGroups { [weak self] in
            guard let self = self else { return }
            self.loadData()
        }
        configureTapHandler()
        regCells()
    }

    private func fetchClientsGroups(completion: () -> ()) {
        firstly {
            networkService.fetchClientsGroups() ?? Promise { _ in [] }
        }.done { group in
            self.saveData(groups: group)
            self.loadData()
        }.catch { error in
            print(error.localizedDescription)
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
            self.performSegue(withIdentifier: SegueIdentifiers.groupNewsScreenName, sender: nil)
        }
    }

    private func saveData(groups: [Group]) {
        dataBaseService.saveData(objects: groups)
    }

    private func loadData() {
        DispatchQueue.global().async {
            guard
                let groups = self.dataBaseService.loadData(objectType: Group.self)
            else { return }

            let groupsNetworkUnits = groups.map { group in
                NetworkUnit(group: group)
            }
            self.networkUnits = groupsNetworkUnits

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
