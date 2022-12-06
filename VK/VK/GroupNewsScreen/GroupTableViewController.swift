// GroupTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран с новостями сообщества.
final class GroupNewsTableViewController: UITableViewController {

    // MARK: - Private constants

    private struct Constant {
        static let defaultGroupID = 97_418_841
    }

    // MARK: - Private enum

    private enum PostCellTypes: String {
        case userReactionCell = "UsersReactionsCell"
        case imageCell = "ImageCell"
        case textCell = "TextCell"
        case nameDateCell = "NameDateCell"
    }

    // MARK: - Public properties

    var posts: [NewsPostItem] = []
    var group: NetworkUnit?

    // MARK: - Private properties

    private let networkService = NetworkService()
    private let cellTypes: [PostCellTypes] = [.nameDateCell, .textCell, .imageCell, .userReactionCell]

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchPosts()
    }

    // MARK: - TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard posts[section].attachments?.first != nil else { return 3 }
        return 4
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        posts.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let wallOwnerGroup = group else { return UITableViewCell() }

        return makeCell(
            tableView: tableView,
            typeOfCell: cellTypes[indexPath.row],
            indexPath: indexPath,
            selectedGroup: wallOwnerGroup
        ) ?? UITableViewCell()
    }

    // MARK: - Private methods

    private func fetchPosts() {
        networkService.fetchPosts(by: -(group?.id ?? -Constant.defaultGroupID)) { response in
            switch response {
            case let .success(success):
                for post in success.response.items {
                    self.posts.append(post)
                }
                self.tableView.reloadData()
            case let .failure(failure):
                print(failure)
            }
        }
    }

    private func makeCell(
        tableView: UITableView,
        typeOfCell: PostCellTypes,
        indexPath: IndexPath,
        selectedGroup: NetworkUnit
    ) -> NewsPostCell? {

        let reusableCell = tableView.dequeueReusableCell(withIdentifier: typeOfCell.rawValue)

        switch typeOfCell {
        case .imageCell:
            guard
                posts[indexPath.section].attachments?.first != nil,
                let cell = reusableCell as? ImageCell
            else {
                guard let cell = tableView
                    .dequeueReusableCell(
                        withIdentifier: PostCellTypes.userReactionCell
                            .rawValue
                    ) as? UsersReactionsCell else { return nil }
                cell.configureCell(post: posts[indexPath.section], group: selectedGroup)
                return cell
            }

            cell.configureCell(post: posts[indexPath.section], group: selectedGroup)
            return cell

        case .nameDateCell:
            guard let cell = reusableCell as? NameDateCell else { return nil }
            cell.configureCell(post: posts[indexPath.section], group: selectedGroup)
            return cell

        case .textCell:
            guard let cell = reusableCell as? TextCell else { return nil }
            cell.configureCell(post: posts[indexPath.section], group: selectedGroup)
            return cell

        case .userReactionCell:
            guard let cell = reusableCell as? UsersReactionsCell else { return nil }
            cell.configureCell(post: posts[indexPath.section], group: selectedGroup)
            return cell
        }
    }

    private func configureTableView() {
        tableView.register(
            UINib(nibName: PostCellTypes.nameDateCell.rawValue, bundle: nil),
            forCellReuseIdentifier: PostCellTypes.nameDateCell.rawValue
        )
        tableView.register(
            UINib(nibName: PostCellTypes.textCell.rawValue, bundle: nil),
            forCellReuseIdentifier: PostCellTypes.textCell.rawValue
        )
        tableView.register(
            UINib(nibName: PostCellTypes.imageCell.rawValue, bundle: nil),
            forCellReuseIdentifier: PostCellTypes.imageCell.rawValue
        )
        tableView.register(
            UINib(nibName: PostCellTypes.userReactionCell.rawValue, bundle: nil),
            forCellReuseIdentifier: PostCellTypes.userReactionCell.rawValue
        )
    }
}
