// FriendPhotoCollectionViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран с фотографиями друга.
final class FriendPhotoCollectionViewController: UICollectionViewController {
    // MARK: Public properties

    var friend: NetworkUnit?
    var handler: TapHandler?

    // MARK: - life cycle

    override func viewDidLoad() {
        configureTapHandler()
    }

    // MARK: - Public methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == SegueIdentifiers.showPhotoSegueText,
            let destination = segue.destination as? ShowFriendPhotoScreenViewController,
            let unit = friend
        else { return }
        destination.friend = unit
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        var view = UICollectionReusableView()
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CellIdentifiers.collectionHeaderID,
                for: indexPath
            )
            view = header
        default:
            break
        }
        return view
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentifiers.photoCollectionViewCellID,
            for: indexPath
        )
        if
            let configCell = cell as? PhotoCollectionViewCell,
            let friend = friend
        {
            configCell.configureCell(unit: friend, handler: handler)
        }
        return cell
    }

    // MARK: - Private methods

    private func configureTapHandler() {
        handler = { unit in
            self.friend = unit
            self.performSegue(withIdentifier: SegueIdentifiers.showPhotoSegueText, sender: nil)
        }
    }

    private func configreGestoreRecognizer() {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(gestoreAction))
        recognizer.direction = .left
        collectionView.addGestureRecognizer(recognizer)
        collectionView.isUserInteractionEnabled = true
    }

    @objc private func gestoreAction() {
        navigationController?.popViewController(animated: true)
    }
}
