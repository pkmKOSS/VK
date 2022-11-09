// FriendListTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

typealias TapHandler = (NetworkUnit) -> ()

/// Экран со списком друзей.
final class FriendListTableViewController: UITableViewController {
    // MARK: - Private visual components

    private var loaderView = Loader()

    // MARK: - Private properties

    private var usersAtSections: [[NetworkUnit]] = [[]]
    private var users: [NetworkUnit] = []
    private var sortedUsers: [NetworkUnit] = []
    private var lettersCountMap: [Dictionary<Character, Int>.Element] = []
    private var sortedlettersMap: [Character: Int] = [:]
    private var lettersMap: [Character: Int] = Alphabets.russianLettersMap
    private var selectedFriend: NetworkUnit?
    private var tapHandler: TapHandler?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCell()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearAllArrays()
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
        guard let char = lettersCountMap[safe: section]?.key else { return nil }
        return String(char)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        sortedlettersMap.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = lettersCountMap[safe: section]?.value else { return 1 }
        return number
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.commonGroupTableViewCellID,
                for: indexPath
            ) as? CommonGroupTableViewCell else { return UITableViewCell() }

        guard usersAtSections.count > 1 else { return UITableViewCell() }
        cell.configureCell(unit: usersAtSections[indexPath.section][indexPath.row], labelNameTapHandler: tapHandler)
        return cell
    }

    // MARK: - Private methods

    private func clearAllArrays() {
        users.removeAll()
        sortedUsers.removeAll()
        lettersCountMap.removeAll()
        sortedlettersMap.removeAll()
        usersAtSections = [[]]
        lettersMap = Alphabets.russianLettersMap
    }

    private func configScreen() {
        configDotsLoader()
        regCells()
        configreTapHandler()
    }

    private func setupCell() {
        makeUsers()
        getFirstLettersCount()
        calculateNumberOfSections()
        sortLettersCountMap()
        putContactsInSections()
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

    private func getFirstLettersCount() {
        sortedUsers = users.sorted(by: { user1, user2 in
            guard
                let user1FirstLetter = user1.name.first,
                let user2FirstLetter = user2.name.first
            else { return false }
            return user1FirstLetter < user2FirstLetter
        })

        for user in sortedUsers {
            for letter in lettersMap where letter.key == user.name.first {
                sortedlettersMap[letter.key] = letter.value + 1
                lettersMap[letter.key]? += 1
            }
        }
    }

    private func calculateNumberOfSections() {
        sortedlettersMap = lettersMap.filter { (_: Character, value: Int) in
            guard value != 0 else { return false }
            return true
        }
    }

    private func sortLettersCountMap() {
        lettersCountMap = sortedlettersMap.sorted(by: <)
    }

    private func putContactsInSections() {
        var letterCounter = 0
        var userCounter = 0
        var array: [NetworkUnit] = []
        for user in sortedUsers {
            array.append(user)
            userCounter += 1
            if userCounter == lettersCountMap[safe: letterCounter]?.value {
                userCounter = 0
                letterCounter += 1
                usersAtSections.append(array)
                array.removeAll()
            }
        }
        usersAtSections.removeFirst()
        sleep(1)
        hideLoadingIndicator()
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
            guard let self = self else { return }
            self.selectedFriend = user
            self.performSegue(withIdentifier: SegueIdentifiers.showFriendSegueText, sender: nil)
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
