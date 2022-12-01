// NetworkUnit.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описание пользователя.
struct NetworkUnit {
    let name: String
    let description: String
    let avatarImageName: String
    let unitImageNames: [String]?
    let id: Int

    init(group: Group) {
        name = group.name
        description = group.screenName
        avatarImageName = group.photo200
        unitImageNames = []
        id = group.id
    }

    init(friend: Friend) {
        name = friend.firstName + " " + friend.lastName
        description = friend.city?.title ?? ""
        avatarImageName = friend.photo ?? ""
        unitImageNames = []
        id = friend.id
    }
}
