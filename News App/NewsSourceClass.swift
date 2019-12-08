//
//  NewsSourceClass.swift
//  News App
//
//  Created by I Am Focused on 12/7/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import Foundation


struct Sources: Codable {
    public var sources: [Source]
}

struct Source: Codable {
    public let id: String
    public let name: String
    public let category: String
    public let description: String
    public let language: String
    public let country: String

}

struct SourcesRequestParameters {
    let category: String?
    let language: String?
    let country: String?

    init(category: String? = nil, language: String? = nil, country: String? = nil) {
        self.category = category
        self.language = language
        self.country = country
    }
}
