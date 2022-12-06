// NewsPostItem.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Пост с новостью
struct NewsPostItem: Decodable {
    let id, date: Int
    let text: String
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let postType: PostType
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
