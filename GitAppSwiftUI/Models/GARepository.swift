//
//  TURepository.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import Foundation

struct GARepository: Codable {
    let id: Int
    let name: String
    let ownerUser: GAOwnerUser
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let repositoryUrl: String
    let updatedAt: String
    let stargazersCount: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case ownerUser = "owner"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case repositoryUrl = "html_url"
        case updatedAt = "updated_at"
        case stargazersCount = "stargazers_count"
        case createdAt = "created_at"
    }
}
