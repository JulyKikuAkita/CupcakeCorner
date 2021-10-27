//
//  iTuneData.swift
//  CupcakeCorner
//
//  Created by Ifang Lee on 10/27/21.
//

import Foundation

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
