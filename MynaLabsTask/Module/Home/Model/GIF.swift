//
//  File.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import Foundation

struct GiphyListModel: Decodable {
    var pagination: Pagenation?
    var data: [GiphyData]?
}

struct Pagenation: Decodable {
    var total_count: Int?
    var count: Int?
    var offset: Int?
}

struct GiphyData: Decodable {
    var id: String?
    var username: String?
    var images: Images?
}

struct Images: Decodable {
    var original: Original?
    var fixedWidth: FixedWidth?
    
    struct Original: Decodable {
        var height: String?
        var width: String?
        var size: String?
        var url: String?
    }
    
    struct FixedWidth: Decodable {
        var height: String?
        var width: String?
        var size: String?
        var url: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case original
        case fixedWidth = "fixed_width_downsampled" // fixed_width_downsampled is fit here nicely when the internet connection is really bad
    }
}
