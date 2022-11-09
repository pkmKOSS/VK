// StringsConstants.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Константы со строками.
struct StringConstants {
    static let segueIdentifier = "loginSegue"
    static let trueLogin = "@gai1_grigorenko"
    static let likeButtonFillImageName = "heart.fill"
    static let likeButtonImageName = "heart"
    static let animationKey = "animation"
    static let animationKeyPath = "keyPath"
}

/// Идентификаторы ячеек.
enum CellIdentifiers {
    static let commonGroupTableViewCellID = "CommonGroupTableViewCell"
    static let photoCollectionViewCellID = "PhotoCollectionViewCell"
    static let collectionHeaderID = "Header"
    static let newTableViewCell = "NewTableViewCell"
}

/// Идентификаторы segue
enum SegueIdentifiers {
    static let addGroupID = "addGroup"
    static let showFriendSegue = "showFriendSegue"
    static let groupNewsScreen = "GroupNewsScreen"
}

/// Перечисление с набором букв алфавита, пригодных для использования в качестве первой буквы фамилии или имени.
enum Alphabets {
    static let russianLettersMap: [Character: Int] = [
        "А": 0,
        "Б": 0,
        "В": 0,
        "Г": 0,
        "Д": 0,
        "Е": 0,
        "Ж": 0,
        "З": 0,
        "И": 0,
        "Й": 0,
        "К": 0,
        "Л": 0,
        "М": 0,
        "Н": 0,
        "О": 0,
        "П": 0,
        "Р": 0,
        "С": 0,
        "Т": 0,
        "У": 0,
        "Ф": 0,
        "Х": 0,
        "Ц": 0,
        "Ч": 0,
        "Ш": 0,
        "Щ": 0,
        "Ы": 0,
        "Э": 0,
        "Ю": 0,
        "Я": 0
    ]
}
