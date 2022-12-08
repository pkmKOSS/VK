// NewsPostItem.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Пост с новостью
struct NewsPostItem: Decodable {
    /// ID и дата новости
    let id, date: Int
    /// Текст новости
    let text: String
    /// Комментарии
    let comments: Comments
    /// Лайки
    let likes: Likes
    /// Репосты
    let reposts: Reposts
    /// Типы поста
    let postType: PostType
    /// Медиа вложения
    let attachments: [Attachment]?

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case text
        case comments, likes, reposts
        case attachments
        case postType = "post_type"
    }
}
