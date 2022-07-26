//
//  Result.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import Foundation

enum Result<Success> {
    case success(Success)
    case badRequest(Failure)
    case failure(String)
}

struct Failure: Codable {
    let statusCode: Int?
    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case statusCode
        case errors
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try? values.decodeIfPresent(Int.self, forKey: .statusCode)
        errors = try? values.decodeIfPresent([String].self, forKey: .errors)
    }
}

