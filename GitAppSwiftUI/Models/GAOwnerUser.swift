//
//  TUOwnerUser.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import Foundation

struct GAOwnerUser: Codable {
    let name: String
    let avatarImageString: String
    let userUrl: String

    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarImageString = "avatar_url"
        case userUrl = "url"
    }
}
