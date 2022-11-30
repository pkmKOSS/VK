// SearchGroupTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран поиска сообществ.
final class SearchGroupTableViewController: UITableViewController {
    // MARK: - Public properties

    var groups: [NetworkUnit] = []
    var hidenGroups: [NetworkUnit] = []
    var searchedGroup: NetworkUnit?

    // MARK: - Private constants

    private struct Constants {
        static let searchParamName = "q"
    }

    // MARK: - Private visual components

    private var searchBar = UISearchBar()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

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

    private func configureScreen() {
        regCells()
        configTableView()
    }

    private func regCells() {
        tableView.register(
            UINib(nibName: CellIdentifiers.commonGroupTableViewCellID, bundle: nil),
            forCellReuseIdentifier: CellIdentifiers.commonGroupTableViewCellID
        )
    }

    private func didRequestUnwind() {
        performSegue(withIdentifier: SegueIdentifiers.addGroupText, sender: nil)
    }

    private func configTableView() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        searchBar.showsCancelButton = true
        searchBar.searchTextField.clearButtonMode = .whileEditing
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
    }
}

// MARK: - UISearchBarDelegate

extension SearchGroupTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NetworkService.shared.fetchFoundGroups(
            parametrsMap: [
                Constants.searchParamName: searchBar.searchTextField.text ?? "",
            ]
        ) { [weak self] result in
            guard let self = self else { return }
            self.groups.removeAll()
            let foundGroups = result.response.items
            for group in foundGroups {
                self.groups.append(NetworkUnit(
                    name: group.name,
                    description: group.screenName,
                    avatarImageName: group.photo200,
                    unitImageNames: [],
                    id: group.id
                ))
            }
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard !hidenGroups.isEmpty else { return }
        groups = hidenGroups
        hidenGroups.removeAll()
        tableView.reloadData()
    }
}
