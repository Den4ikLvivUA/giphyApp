//
//  DataStructures.swift
//  giphyApp
//
//  Created by MacBook on 5/21/20.
//  Copyright © 2020 den4iklvivua. All rights reserved.
//

import Foundation

public struct giphyGetImageResponse: Codable {
    var meta: meta
    var pagination: pagination
    var data: [data]
}

public struct data: Codable {
    var type: String
    var title: String
    var id: String
    var images: images
}

public struct images: Codable {
    var original: image
}

public struct image: Codable {
    var width: String
    var height: String
    var size: String
    var url: String
}


//MARK: - Pagination & Status

public struct meta: Codable {
    var msg: String
    var response_id : String
    var status: Int
}

public struct pagination: Codable {
    var total_count: Int
    var offset : Int
    var count: Int
}
