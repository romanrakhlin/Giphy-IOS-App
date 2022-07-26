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
    var downsized: DownSized?
    
    struct DownSized: Decodable {
        var height: String?
        var width: String?
        var size: String?
        var url: String?
    }
}
