//
//  HomeRouter.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import Foundation

enum HomeRouter: BaseRouter {
    
    case fetchGIFs

    var path: String {
        switch self {
        case .fetchGIFs:
            return "/v1/gifs/trending"
        }
    }

    var method: HttpMethod {
        switch self {
        case .fetchGIFs:
            return .GET
        }
    }

    var httpBody: Data? {
        switch self {
        case .fetchGIFs:
            return nil
        }
    }

    var httpHeader: [HttpHeader]? {
        switch self {
        case .fetchGIFs:
            return nil
        }
    }
}
