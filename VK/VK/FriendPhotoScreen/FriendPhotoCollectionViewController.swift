// FriendPhotoCollectionViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран с фотографиями друга.
final class FriendPhotoCollectionViewController: UICollectionViewController {
    // MARK: Public properties

    var friend: NetworkUnit?

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
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
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: CellIdentifiers.photoCollectionViewCellID,
                for: indexPath
            ) as? PhotoCollectionViewCell,
            let friend = friend
        else {
            return UICollectionViewCell()
        }
        cell.configureCell(unit: friend)
        return cell
    }
}
