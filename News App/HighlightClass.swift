//
//  HighlightClass.swift
//  News App
//
//  Created by Hang Thanh on 12/30/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import Foundation

struct Highlights: Codable {
    public var sources: [Highlight]
}

struct Highlight: Codable {
    public let newsURL: String
    public let color: Int
    public let range: [Int]

}
