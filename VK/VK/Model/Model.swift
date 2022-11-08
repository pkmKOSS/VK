// Model.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Описание пользователя.
struct User: NetworkUnit {
    var name: String
    var description: String
    var avatarImageName: String
    var unitImageNames: [String]?
}

/// Описание сообщества.
struct Group: NetworkUnit {
    var name: String
    var description: String
    var avatarImageName: String
    var unitImageNames: [String]?
}

/// Протокол описывающий сущность в социальной сети - пользователя и сообщество.
protocol NetworkUnit {
    var name: String { get set }
    var description: String { get set }
    var avatarImageName: String { get set }
    var unitImageNames: [String]? { get set }
}
