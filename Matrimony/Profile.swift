//
//  Profile.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 05/05/24.
//

import Foundation

struct RandomProfileResponse: Codable {
    let results: [RandomProfile]
    let info: Info
    
    struct Info: Codable {
        let seed: String
        let results: Int
        let page: Int
        let version: String
    }
}

// Define RandomProfile struct to represent each profile in the response
struct RandomProfile: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: Dob
    let registered: Registered
    let phone: String
    let cell: String
    let id: Id
    let picture: Picture
    let nat: String
    
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }
    
    struct Location: Codable {
        let street: Street
        let city: String
        let state: String
        let country: String
        let postcode: PostalCode
        let coordinates: Coordinates
        let timezone: Timezone
        
        struct Street: Codable {
            let number: Int
            let name: String
        }
        
        struct Coordinates: Codable {
            let latitude: String
            let longitude: String
        }
        
        struct Timezone: Codable {
            let offset: String
            let description: String
        }
    }
    
    struct Login: Codable {
        let uuid: String
        let username: String
        let password: String
        let salt: String
        let md5: String
        let sha1: String
        let sha256: String
    }
    
    struct Dob: Codable {
        let date: String
        let age: Int
    }
    
    struct Registered: Codable {
        let date: String
        let age: Int
    }
    
    struct Id: Codable {
        let name: String
        let value: String?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            value = try container.decodeIfPresent(String.self, forKey: .value) // Decode as optional string
        }
    }
    
    struct Picture: Codable {
        let large: String
        let medium: String
        let thumbnail: String
    }
}

// Define an enum to represent the postcode as both string and integer
enum PostalCode: Codable {
    case string(String)
    case integer(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .integer(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(PostalCode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Int or String for postcode"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .integer(let value):
            try container.encode(value)
        }
    }
}

// Modify RandomProfile to conform to Hashable
extension RandomProfile: Hashable {
    static func == (lhs: RandomProfile, rhs: RandomProfile) -> Bool {
        // Compare profiles based on their unique identifier, such as UUID or any other unique property
        return lhs.login.uuid == rhs.login.uuid
    }

    func hash(into hasher: inout Hasher) {
        // Use the hash value of the profile's unique identifier for hashing
        hasher.combine(login.uuid)
    }
}
