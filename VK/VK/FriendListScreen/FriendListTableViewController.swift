// FriendListTableViewController.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift
import UIKit

typealias TapHandler = (NetworkUnit) -> ()

/// Экран со списком друзей.
final class FriendListTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    // MARK: - Private constants

    private struct Constants {
        static let defaultRawValue = 0
        static let emptyCharacter = Character(" ")
        static let emptyString = " "
    }

    // MARK: - Private @IBOutlet

    @IBOutlet private var countOfFriendsLabel: UILabel!

    // MARK: - Private visual components

    private var loaderView = Loader()

    // MARK: - Private properties

    private let networkService = NetworkService()
    private let dataBaseService = DataBaseService()
    private var sortedFriendsMap: [Character: [NetworkUnit]] = [:]
    private var selectedFriend: NetworkUnit?
    private var tapHandler: TapHandler?
    private var notificationToken = NotificationToken()

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
        return sortedFriendsMap[key]?.count ?? Constants.defaultRawValue
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
        setupScene()
        setupNotToken()
        fetchFriends()
    }

    private func fetchFriends() {
        let fetchFriendOperationQueue = OperationQueue()
        let asyncOperation = FetchFriendsAsyncOperation(networkService: networkService)
        let saveDataOperation = SaveDataOperation(
            dataBaseService: dataBaseService,
            operation: asyncOperation
        )
       
        saveDataOperation.addDependency(asyncOperation)
        fetchFriendOperationQueue.addOperations([asyncOperation, saveDataOperation], waitUntilFinished: false)

        saveDataOperation.completionBlock = { [weak self] in
            guard let self = self else { return }
            self.loadData()
        }
    }

    private func saveData(friends: [Friend]) {
        dataBaseService.saveData(objects: friends)
    }

    private func loadData() {
        DispatchQueue.global().async {
            guard
                let friends = self.dataBaseService.loadData(objectType: Friend.self)
            else { return }

            let friendsNetworkUnits = friends.map {
                NetworkUnit(friend: $0)
            }
            DispatchQueue.main.async {
                self.updateFriendsLabelText(count: friends.count)
                self.makeFriendsSortedMap(friends: friendsNetworkUnits)
                self.tableView.reloadData()
            }
        }
    }

    /// был вариант с батч апдейт,  все работало. Проверял принтами и инсертами новых друзей. Потом сломалось
    /// параллельное открытие файла. Оставил так.
    private func setupNotToken() {
        dataBaseService.observeChanges(
            type: Friend.self,
            notToken: &notificationToken
        ) { changes in
            switch changes {
            case .initial:
                break
            case .update:
                self.tableView.reloadData()
            case let .error(error):
                print(error.localizedDescription)
            }
        }
    }

    private func setupScene() {
        regCells()
        configureTapHandler()
    }

    private func updateFriendsLabelText(count: Int) {
        countOfFriendsLabel.text = String(count)
    }

    private func makeFriendsSortedMap(friends: [NetworkUnit]) {
        var friendsMap: [Character: [NetworkUnit]] = [:]
        friends.forEach {
            guard let key = $0.name.first else { return }
            guard
                friendsMap[key] == nil
            else {
                friendsMap[key]?.append($0)
                friendsMap[key]?.sort {
                    $0.name.first ?? Constants.emptyCharacter > $1.name.first ?? Constants.emptyCharacter
                }
                return
            }
            friendsMap[key] = [$0]
        }
        sortedFriendsMap = friendsMap
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

    private func configureTapHandler() {
        tapHandler = { [weak self] user in
            guard
                let self = self,
                let friendPhotoViewController = self.storyboard?
                .instantiateViewController(
                    withIdentifier: ViewControllersID
                        .friendPhotoText
                ) as? FriendPhotoCollectionViewController
            else { return }
            friendPhotoViewController.friend = user
            friendPhotoViewController.transitioningDelegate = self
            self.navigationController?.pushViewController(friendPhotoViewController, animated: true)
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
