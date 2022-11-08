// StringsConstants.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Константы со строками.
struct StringConstants {
    /// ID перехода с экрана авторизации.
    static let segueIdentifier = "loginSegue"
    /// Верный логин для входа.
    static let trueLogin = "@gai1_grigorenko"
    static let likeButtonFillImageName = "heart.fill"
    static let likeButtonImageName = "heart"
}

/// Идентификаторы ячеек.
enum CellIdentifiers {
    static let commonGroupTableViewCellID = "CommonGroupTableViewCell"
    static let photoCollectionViewCellID = "PhotoCollectionViewCell"
    static let collectionHeaderID = "Header"
}

/// Идентификаторы segue
enum SegueIdentifiers {
    static let addGroupID = "addGroup"
    static let showFriendSegue = "showFriendSegue"
}
