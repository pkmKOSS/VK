// FriendListTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

typealias TapHandler = (NetworkUnit) -> ()

/// Экран со списком друзей.
final class FriendListTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    // MARK: - Private constants

    private struct Constants {
        static let fieldsValue = "city, photo_200_orig"
        static let fieldsName = "fields"
        static let emptyCharacter = Character(" ")
    }

    // MARK: - Private visual components

    private var loaderView = Loader()

    // MARK: - Private properties

    private var sortedFriendsMap: [Character: [NetworkUnit]] = [:]
    private var selectedFriend: NetworkUnit?
    private var tapHandler: TapHandler?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == SegueIdentifiers.showFriendSegueText,
            let destination = segue.destination as? FriendPhotoCollectionViewController,
            let friend = selectedFriend
        else { return }
        destination.friend = friend
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedKeys = sortedFriendsMap.keys.sorted()
        return String(sortedKeys[section])
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        sortedFriendsMap.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedKeys = sortedFriendsMap.keys.sorted()
        let key = sortedKeys[section]
        return sortedFriendsMap[key]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.commonGroupTableViewCellID,
                for: indexPath
            ) as? CommonGroupTableViewCell
        else { return UITableViewCell() }

        let sortedKeys = sortedFriendsMap.keys.sorted()
        let key = sortedKeys[indexPath.section]
        guard
            let friendsListSection = sortedFriendsMap[key],
            let friendsInfo = friendsListSection[safe: indexPath.row]
        else { return UITableViewCell() }
        cell.configureCell(unit: friendsInfo, labelNameTapHandler: tapHandler)
        return cell
    }

    // MARK: - Private methods

    private func configureScreen() {
        fetchFriends()
        configScreen()
    }

    private func fetchFriends() {
        NetworkServiceble.shared.fetchFriends(
            parametersMap: [
                Constants.fieldsName: Constants.fieldsValue,
            ]
        ) { friends in
            let array = (friends as? ResponseWithFriends)?.response.items.map { friend in
                NetworkUnit(
                    name: "\(friend.firstName) \(friend.lastName)",
                    description: friend.city?.title ?? String(Constants.emptyCharacter),
                    avatarImageName: friend.photo ?? String(Constants.emptyCharacter),
                    unitImageNames: [],
                    id: friend.id
                )
            }
            self.makeFriendsSortedMap(friendsInfo: array ?? [])
            self.tableView.reloadData()
        }
    }

    private func configScreen() {
        // configDotsLoader()
        regCells()
        configreTapHandler()
    }

    private func setupCell() {
        configScreen()
    }

    private func makeFriendsSortedMap(friendsInfo: [NetworkUnit]) {
        var friendsMap: [Character: [NetworkUnit]] = [:]
        for info in friendsInfo {
            if let key = info.name.first {
                if friendsMap[key] == nil {
                    friendsMap[key] = [info]
                } else {
                    friendsMap[key]?.append(info)
                    friendsMap[key]?.sort {
                        $0.name.first ?? Constants.emptyCharacter > $1.name.first ?? Constants.emptyCharacter
                    }
                }
            }
        }
        sortedFriendsMap = friendsMap
        tableView.reloadData()
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
            guard
                let self = self,
                let vc = self.storyboard?
                .instantiateViewController(
                    withIdentifier: ViewControllersID
                        .friendPhotoText
                ) as? FriendPhotoCollectionViewController
            else { return }
            vc.friend = user
            vc.transitioningDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func configDotsLoader() {
        loaderView = Loader(frame: CGRect(x: 0, y: 0, width: 50, height: 50), tintColor: .systemBlue)
        tableView.addSubview(loaderView)
        loaderView.center = tableView.center
    }

    private func hideLoadingIndicator() {
        loaderView.isHidden = true
    }
}
