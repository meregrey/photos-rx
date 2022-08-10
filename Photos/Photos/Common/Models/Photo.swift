//
//  Photo.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/04.
//

import Foundation

struct Photo: Decodable {
    var url: URL? { URL(string: link.string) }
    var userName: String { user.name }
    
    private let link: Link
    private let user: User
    
    enum CodingKeys: String, CodingKey {
        case link = "urls"
        case user
    }
}

extension Photo {
    struct Link: Decodable {
        let string: String
        
        enum CodingKeys: String, CodingKey {
            case string = "regular"
        }
    }
}

extension Photo {
    struct User: Decodable {
        let name: String
    }
}
